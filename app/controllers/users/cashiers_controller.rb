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
    cashier_role=Role.find_by_name(Role::AS[:cashier])
    if current_user.employees.where(:role_id=>cashier_role.id).empty?
      respond_to do |format|
        format.xml { render :text => "User is not cashier" ,:status=>500 }
      end
    end
  end
end
