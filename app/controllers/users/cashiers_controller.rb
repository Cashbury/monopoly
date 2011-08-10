class Users::CashiersController < Users::BaseController
  before_filter :require_cashier, :except=>[:check_user_role]
  def check_user_role
    begin
      cashier_role = Role.find_by_name(Role::AS[:cashier])
      employee = Employee.where(:user_id=>current_user.id, :role_id=>cashier_role.id).first
      result={}
      result["is_cashier"]= employee.present?
      result["business-id"]= employee.present? ? employee.business_id : nil
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
        unless params[:engagements].blank?
          params[:engagements].each do |record| 
            if record.present?
              records= record.split(',')
              engagement_id= records.first;quantity=records.second
              engagement= Engagement.find(engagement_id)
              result= user.engaged_with(engagement,engagement.amount,nil,nil,params[:lat],params[:long],"User made an engagement through cashier",quantity.to_i, result[:log_group])              
            end
          end
        end
        #Spend based campaign    
        campaign=business.spend_based_campaign
        if campaign.present? and campaign.engagements.first.end_date > Date.today
          user.made_spend_engagement_at(qr_code, business, campaign, params[:amount].to_f, params[:lat], params[:lng], result[:log_group], current_user.id)
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
  
  def require_cashier
    unless current_user.role?(Role::AS[:cashier]) #|| current_user.role?(Role::AS[:admin])
      respond_to do |format|
        format.xml { render :text => "User is not a cashier" ,:status=>500 }
      end
    end
  end
end
