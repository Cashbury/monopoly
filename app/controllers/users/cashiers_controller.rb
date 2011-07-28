class Users::CashiersController < Users::BaseController
  before_filter :require_cashier, :except=>[:check_user_role]
  def check_user_role
    begin
      cashier_role=Role.find_by_name(Role::AS[:cashier])
      employee=Employee.where(:user_id=>current_user.id, :role_id=>cashier_role.id).first
      result={}
      result["is_cashier"]=employee.present?
      result["business-id"]=employee.present? ? employee.business_id : nil
      respond_to do |format|
        format.xml { render :xml =>result,:status=>200 }
      end
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}"
      render :text => e.message, :status => 500
    end
  end
  
  def ring_up
    qr_code=QrCode.associated_with_users.where(:hash_code=>params[:customer_identifier]).first
    user=qr_code.user if qr_code.present?
    employee=current_user.employees.where(:role_id=>Role.find_by_name(Role::AS[:cashier]).id).first   
    business=Business.find(employee.business_id)
    user_type=user.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
    #Loyalty collect campaigns
    unless params[:engagements].blank?
      params[:engagements].each do |record| 
        records=record.split(',')
        engagement_id=records.first;quantity=records.second
        engagement=Engagement.find(engagement_id)
        user.engaged_with(engagement,nil,nil,params[:lat],params[:long],"User made an engagement through cashier",quantity.to_i)
      end
    end
    #Spend based campaign    
    campaign=business.spend_based_campaign
    user.made_spend_engagement_at(business,campaign,params[:amount].to_f,params[:lat],params[:lng])
    s = {}
		s.merge!({:amount             => params[:amount]})
		s.merge!({:currency_symbol    => ISO4217::Currency.from_code(business.currency_code).symbol})
		s.merge!({:customer_name      => user.full_name})
		s.merge!({:customer_type      => user_type})
		user_uid=user.email.split("@facebook").first
    s.merge!({:customer_image_url => URI.escape(user.email.match(/facebook/) ? "https://graph.facebook.com/#{user_uid}/picture" : "/images/user-default.jpg")})
    respond_to do |format|     
      format.xml {render :xml => s , :status => 200}
    end
  end
  
  def list_engagements_items
   @items=Item.joins(:engagements=>[:campaign=>[:program=>:business]])
              .where("businesses.id=#{params[:business_id]} and ((campaigns.end_date IS NOT null AND '#{Date.today}' BETWEEN campaigns.start_date AND campaigns.end_date) || '#{Date.today}' >= campaigns.start_date)")
              .select("engagements.id as engagement_id, items.id as item_id, items.name as item_name")
   @result={}  
   @result["items"]=[]         
   @items.each_with_index do |item,index|     
     item_obj=Item.find(item.item_id)
     @result["items"][index]=item.attributes
     @result["items"][index]["item-image-url"]=item_obj.item_image ? URI.escape(item_obj.item_image.photo.url(:thumb)): nil
   end
   
   respond_to do |format|
      format.xml { render :xml => @result }
    end
  end
  
  def require_cashier
    unless current_user.role?(Role::AS[:cashier]) and current_user.role?(Role::AS[:admin])
      respond_to do |format|
        format.xml { render :text => "User is neither cashier nor admin" ,:status=>500 }
      end
    end
  end
end
