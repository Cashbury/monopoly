class Users::ReceiptsController < Users::BaseController
  after_filter :delete_all_receipts, :only=>[:index]
  def index
    all_receipts=current_user.list_customer_pending_receipts
    result={}
    result[:receipts]=[]
    all_receipts.each_with_index do |receipt,index|
      brand=Brand.find(receipt.brand_id)
      result[:receipts][index]= receipt.attributes
      result[:receipts][index][:currency_symbol] = Business.find(receipt.business_id).currency_symbol
      result[:receipts][index][:brand_image_fb]  = brand.try(:brand_image).nil? ? nil : URI.escape(brand.brand_image.photo.url(:thumb))
      log_group=LogGroup.where(:id=>receipt.log_group_id).first
      if log_group.present?
        result[:receipts][index][:engagements]=[]
        logs=log_group.get_receipt_engagements        
        logs.each_with_index do |log,i|
          result[:receipts][index][:engagements][i]=log.attributes
        end
      end
    end
    respond_to do |format|       
      format.xml { render :xml => result,:status=>200 }
    end
  end
  
  def list_receipts_history
    @all_receipts=current_user.list_customer_all_receipts
    respond_to do |format|
      format.xml {}
    end
  end
  
  def delete_all_receipts
    #remove all current user receipts after listing
    current_user.pending_receipts.clear
  end
end
