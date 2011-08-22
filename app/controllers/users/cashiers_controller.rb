class Users::CashiersController < Users::BaseController
  before_filter :require_cashier, :except=>[:check_user_role]
  def check_user_role
    begin
      cashier_role = Role.find_by_name(Role::AS[:cashier])
      employee = Employee.where(:user_id=>current_user.id, :role_id=>cashier_role.id).first
      result={}
      result["is_cashier"]   = employee.present?
      if employee.present? 
        result["business_id"]  = employee.business_id
        business= employee.business_id.present? ? Business.find(employee.business_id) : nil
        if business.present?
          result["flag_url"]     = business.country.present? ? "http://#{request.host_with_port}/images/countries/#{business.country.iso2.to_s.downcase}.png" : nil
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
  
  def ring_up
    begin
      qr_code=QrCode.associated_with_users.where(:hash_code=>params[:customer_identifier]).first
      if qr_code.present? and qr_code.status #active
        user=qr_code.user
        employee= current_user.employees.where(:role_id=>Role.find_by_name(Role::AS[:cashier]).id).first   
        business= Business.find(employee.business_id)
        user_type= user.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
        #Loyalty collect campaigns
        result={}
        engagements=[]
        unless params[:engagements].blank?
          params[:engagements].each do |record| 
            if record.present?
              records= record.split(',')
              engagement_id= records.first;quantity=records.second
              engagement= Engagement.find(engagement_id)
              result= user.engaged_with(engagement,engagement.amount,qr_code,nil,params[:lat],params[:long],"User made an engagement through cashier",quantity.to_i, result[:log_group], current_user.id)              
              engagement_data={:current_balance=>result[:user_account].amount, :campaign_id=> result[:campaign].id, :amount=> result[:after_fees_amount], :title=> engagement.name, :quantity=> result[:frequency] }
              engagements.map!{ |x| 
                if x[:campaign_id]==result[:campaign].id
                  x[:current_balance]=result[:user_account].amount
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
        campaign=business.spend_based_campaign
        if campaign.present? and campaign.engagements.first.end_date > Date.today
          user.made_spend_engagement_at(qr_code, business, campaign, params[:amount].to_f, params[:lat], params[:long], result[:log_group], current_user.id)
          #user.issue_qrcode(current_user.id, qr_code.size, qr_code.code_type)
          #qr_code.scan
        end
        s = {}
		    s.merge!({:amount             => params[:amount]})
		    s.merge!({:currency_symbol    => business.currency_symbol})
		    s.merge!({:customer_name      => user.full_name})
		    s.merge!({:customer_type      => user_type})
		    user_uid=user.email.split("@facebook").first
        s.merge!({:customer_image_url => URI.escape(user.email.match(/facebook/) ? "https://graph.facebook.com/#{user_uid}/picture" : "/images/user-default.jpg")})
        s.merge!({:engagements        =>engagements})
        respond_to do |format|     
          format.xml {render :xml => s , :status => 200}
        end
      else
        respond_to do |format|     
          format.xml {render :text => "Invalid Qrcode"  , :status => 200}
        end
      end
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}"
      respond_to do |format|     
        format.xml {render :text => e.message  , :status => 200}
      end
    end
  end
  
  def list_engagements_items
   @items= Item.list_engagements_items(params[:business_id])   
   @result={}  
   @result["items"]=[]         
   @items.each_with_index do |item,index|     
     item_obj=Item.find(item.item_id)
     @result["items"][index]=item.attributes
     @result["items"][index]["item-image-url"]=item_obj.item_image ? URI.escape(item_obj.item_image.photo.url(:normal)): nil
   end
   
   respond_to do |format|
      format.xml { render :xml => @result }
    end
  end
  
  def list_receipts_history
    required_dates= Receipt.select("DISTINCT Date(created_at) as date").order("created_at DESC").limit(params[:no_of_days].to_i)
    @required_dates_array=required_dates.collect{|d| "'#{d.date.to_s(:db)}'"}
    collected_dates= "("+@required_dates_array.join(',')+")"
    @all_receipts=current_user.list_cashier_receipts(collected_dates)
    
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
