class Users::CashiersController < Users::BaseController
  before_filter :require_cashier, :except=>[:check_user_role]
  def check_user_role
    begin
      cashier_role = Role.find_by_name(Role::AS[:cashier])
      employee = Employee.where(:user_id=>current_user.id, :role_id=>cashier_role.id).first
      result={}
      result["is_cashier"]  = employee.present?
      if employee.present? 
        result["business_id"]    = employee.business_id
        business= employee.business_id.present? ? Business.find(employee.business_id) : nil
        if business.present?
          result["flag_url"]     = business.country.present? ? "http://#{request.host_with_port}#{COUNTRIES_FLAGS_PATH}#{business.country.iso2.to_s.downcase}.png" : nil
          result["currency_code"]= business.currency_code
        end
      end
      respond_to do |format|
        format.xml { render :xml =>result,:status=>200 }
      end
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}"
      render :text => e.message, :status => 500
    end
  end

  def load_money
    begin
      qr_code = QrCode.associated_with_users.where(:hash_code => params[:customer_identifier]).first
      if qr_code.present? and qr_code.status #active
        amount = params[:amount].nil? ? 0: params[:amount].to_f
        user = qr_code.user
        employee = current_user.employees.where(:role_id=>Role.find_by_name(Role::AS[:cashier]).id).first   
        business = Business.find(employee.business_id)

        raise "Cannot load money if business is not in Money Program" unless business.has_money_program?

        user_type = user.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
        account = user.cash_account_for(business)
        error_message = ""
        if account.nil?
          #create the account at the business if it doesn't exist
          user.enroll(business.money_program)
          account = user.cash_account_for(business)
          raise "Error auto enrolling user into business money program" if account.blank?
        end
        account.load(amount,employee)
        transaction_id = Transaction.find_all_by_to_account(account.id).last.id
        user.create_load_transaction_receipt(current_user.id, transaction_id)
        user.qr_code.reissue if user.qr_code.single_use?
        response = {}
		    response.merge!({:amount             => amount})
		    response.merge!({:transaction_id     => transaction_id})
		    response.merge!({:currency_symbol    => business.currency_symbol})
		    response.merge!({:currency_code      => business.currency_code})
		    response.merge!({:customer_name      => user.full_name})
		    response.merge!({:customer_type      => user_type})
		    user_uid=user.email.split("@facebook").first
        response.merge!({:customer_image_url => URI.escape(user.email.match(/facebook/) ? "https://graph.facebook.com/#{user_uid}/picture" : "/images/user-default.jpg")})
        respond_to do |format|     
          format.xml {render :xml => response , :status => 200}
        end
      else
        respond_to do |format|     
          format.xml {render :text => "Invalid Qrcode"  , :status => 422 }
        end
      end
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}, #{e.backtrace}"
      respond_to do |format|     
        format.xml {render :text => e.message  , :status => 500 }
      end
    end
  end

  def charge_customer
    #begin
      result = {}
      qr_code = QrCode.associated_with_users.where(:hash_code => params[:customer_identifier]).first
      if qr_code.present? and qr_code.status #active
        amount = params[:amount].nil? ? 0 : params[:amount].to_f
        tip = params[:tip].nil? ? 0 : params[:tip].to_f
        total_amount = amount + tip
        user = qr_code.user
        employee = current_user.employees.where(:role_id => Role.find_by_name(Role::AS[:cashier]).id).first
        business = Business.find(employee.business_id)        
        user_type = user.engaged_with_business?(business) ? "Returning Customer" : "New Customer"

        cash_account = user.cash_account_for(business)
        cashbury_account = user.cashbury_account_for(business)
        if tip > 0 
          place = Place.where(:business_id => business.id).closest(:origin => [params[:lat].to_f, params[:lng].to_f]).first
          tip_account = user.tip_account_for(place)
        end
        available_balance = 0
        cash_balance = cash_account.nil? ? 0 : cash_account.amount.to_f
        cashbury_balance = cashbury_account.nil? ? 0 : cashbury_account.amount.to_f
        available_balance = cash_balance + cashbury_balance

        credit_used = available_balance <= total_amount ? available_balance : total_amount        
        engagements = []
        current_log = nil

        txn_group = Account.group_transactions do 
          log_group = Log.group_logs do                  
            cash_account.spend(total_amount) if total_amount > 0            
            tip_account.tip(tip, current_user) if tip > 0 #tip deposit TX SVA (not money account already the tip money transfer is within the spend TX)            
            #Loyalty collect campaigns
            unless params[:engagements].blank?
              params[:engagements].each do |record| 
                if record.present?
                  records = record.split(',')
                  engagement_id = records.first.strip
                  quantity = records.second.strip
                  engagement = Engagement.find(engagement_id)
                  campaign = engagement.campaign
                  user_account = campaign.user_account(user)
                  biz_account = campaign.business_account
                  options = {
                    :user => user,
                    :action => Action[:engagement],
                    :amount => engagement.amount,
                    :associatable => engagement,
                    :campaign => campaign,
                    :from_account => biz_account,
                    :to_account => user_account,
                    :freq => quantity.to_i,                  
                    :lat => params[:lat],
                    :lng => params[:long],
                    :note => "User made an engagement through cashier",
                    :issued_by => current_user.id
                  }                
                  Transaction.fire(options)                
                  engagement_data = {:current_balance => campaign.user_account(user).amount, :campaign_id => campaign.id, :amount => engagement.amount, :title => engagement.name, :quantity => quantity }
                  engagements << engagement_data
                end
              end
            end

            #Spend based campaign (Marketing Program Transactions)  
            campaign = business.spend_based_campaign
            campaign_engagement = campaign.try(:engagements).try(:first)
            engagement_valid = campaign_engagement.present? and (!campaign_engagement.end_date || campaign_engagement.end_date > Date.today)
            if campaign.present? and engagement_valid              
              options = {
                :spend_campaign => campaign,
                :earned_points => total_amount - credit_used,
                :lat => params[:lat],
                :lng => params[:long],
                :issued_by => current_user.id
              }              
              result = user.spend_engage!(options)              
            end
          end
          current_log = log_group
        end
        
        options = {
          :cashier_id => current_user.id,
          :txn_group_id => txn_group.id,
          :credit_used => credit_used,
          :business => business,
          :tip => tip,
          :ringup_amount => amount,
          :current_credit => result[:current_credit],
          :txn_group_id => txn_group.id,          
          :unlocked_credit => result[:unlocked_credit] || 0,
          :remaining_credit => result[:remaining_credit] || 0,
          :log_group_id => current_log.id,
          :earned_points => total_amount - credit_used
        }        
        user.create_charge_transaction_group_receipt(options)
        user.qr_code.reissue if user.qr_code.single_use?
        response = {}
		    response.merge!({:amount             => amount})
		    response.merge!({:tip                => tip})
		    response.merge!({:transaction_group_id => txn_group.id})
		    response.merge!({:currency_symbol    => business.currency_symbol})
		    response.merge!({:currency_code      => business.currency_code})
		    response.merge!({:customer_name      => user.full_name})
		    response.merge!({:customer_type      => user_type})
		    user_uid = user.email.split("@facebook").first
        response.merge!({:customer_image_url => URI.escape(user.email.match(/facebook/) ? "https://graph.facebook.com/#{user_uid}/picture" : "/images/user-default.jpg")})
        respond_to do |format|     
          format.xml {render :xml => response , :status => 200}
        end
      else
        raise ApiError.new("Invalid QrCode", 422)
      end
    #rescue ApiError => ae
    #  respond_to do |format|
    #    format.xml { render :xml => ae, :status => ae.status_code }
    #  end
    #rescue Exception =>e
    #  logger.error "Exception #{e.class}: #{e.message}"
    #  respond_to do |format|     
    #    format.xml {render :text => e.message  , :status => 500 }
    #  end
    #end
  end
  
  def ring_up
    begin
      qr_code = QrCode.associated_with_users.where(:hash_code => params[:customer_identifier]).first
      if qr_code.present? and qr_code.status #active
        user = qr_code.user
        employee = current_user.employees.where(:role_id => Role.find_by_name(Role::AS[:cashier]).id).first   
        business = Business.find(employee.business_id)
        user_type = user.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
        #Loyalty collect campaigns
        result = {}
        engagements = []
        unless params[:engagements].blank?
          params[:engagements].each do |record| 
            if record.present?
              records = record.split(',')
              engagement_id = records.first;quantity=records.second
              engagement = Engagement.find(engagement_id)
              result = user.engaged_with(engagement,engagement.amount,qr_code,nil,params[:lat],params[:long],"User made an engagement through cashier",quantity.to_i, result[:log_group], current_user.id)              
              engagement_data = {:current_balance => result[:user_account].amount, :campaign_id => result[:campaign].id, :amount => result[:after_fees_amount], :title => engagement.name, :quantity => result[:frequency] }
              engagements.map!{ |x| 
                if x[:campaign_id] == result[:campaign].id
                  x[:current_balance] = result[:user_account].amount
                  x
                else
                  x
                end
              }
              engagements << engagement_data
            end
          end
        end
        #Spend based campaign   
        campaign = business.spend_based_campaign
        campaign_engagement = campaign.try(:engagements).try(:first)
        engagement_valid = (!campaign_engagement.end_date || campaign_engagement.end_date > Date.today)
        if campaign.present? and engagement_valid
          result = user.made_spend_engagement_at(qr_code, business, campaign, params[:amount].to_f, params[:lat], params[:long], result[:log_group], current_user.id)
          #user.issue_qrcode(current_user.id, qr_code.size, qr_code.code_type)
          #qr_code.scan
        end
        s = {}
		    s.merge!({:amount             => params[:amount]})
		    s.merge!({:transaction_id     => result[:transaction].try(:id)})
		    s.merge!({:currency_symbol    => business.currency_symbol})
		    s.merge!({:currency_code      => business.currency_code})
		    s.merge!({:customer_name      => user.full_name})
		    s.merge!({:customer_type      => user_type})
		    user_uid = user.email.split("@facebook").first
        s.merge!({:customer_image_url => URI.escape(user.email.match(/facebook/) ? "https://graph.facebook.com/#{user_uid}/picture" : "/images/user-default.jpg")})
        s.merge!({:engagements        => engagements})
        respond_to do |format|     
          format.xml {render :xml => s , :status => 200}
        end
      else
        respond_to do |format|     
          format.xml {render :text => "Invalid Qrcode"  , :status => 422}
        end
      end
    rescue Exception => e
      logger.error "Exception #{e.class}: #{e.message}"
      respond_to do |format|     
        format.xml {render :text => e.message  , :status => 500}
      end
    end
  end
  
  def list_engagements_items
   @items = Item.list_engagements_items(params[:business_id])   
   @result ={}  
   @result["items"] = []         
   @items.each_with_index do |item,index|     
     item_obj = Item.find(item.item_id)
     @result["items"][index] = item.attributes
     @result["items"][index]["item-image-url"] = item_obj.item_image ? URI.escape(item_obj.item_image.photo.url(:normal)): nil
   end
   
   respond_to do |format|
      format.xml { render :xml => @result }
    end
  end
  
  def list_receipts_history
    @all_receipts = current_user.list_cashier_receipts(params[:no_of_days].to_i)   
    @dates = @all_receipts.collect {|r| r.date_time.to_date }.uniq
    respond_to do |format|
      format.xml {}
    end
  end
  
  def require_cashier
    unless current_user.role?(Role::AS[:cashier]) #|| current_user.role?(Role::AS[:admin])
      respond_to do |format|
        format.xml { render :text => "User is not a cashier" ,:status=>500 }
      end
    end
  end
end
