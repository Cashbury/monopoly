class Users::ReceiptsController < Users::BaseController

  after_filter :delete_all_receipts, :only => [:index]
  
  def index
    @all_receipts = current_user.list_customer_pending_receipts
    respond_to do |format|
      format.xml
    end
  end
  
  def list_receipts_history
    @all_receipts = current_user.list_customer_all_receipts(params[:business_id])    
    respond_to do |format|
      format.xml
    end
  end
  
  def delete_all_receipts
    #remove all current user receipts after listing
    current_user.pending_receipts.clear
  end
end
