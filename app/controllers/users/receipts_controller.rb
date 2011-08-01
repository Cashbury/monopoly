class Users::ReceiptsController < Users::BaseController
  def index
    all_receipts=current_user.receipts.joins([:business,:place=>:address]).select("receipts.amount,receipts.business_id, receipts.place_id, receipts.receipt_text,receipts.receipt_type, receipts.user_id, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, businesses.name as business_name")
    result={}
    all_receipts.each do |receipt|
      result[:receipt]=receipt.attributes
      result[:receipt][:currency_symbol]=Business.find(receipt.business_id).currency_symbol
    end
    respond_to do |format|       
      format.xml { render :xml => result,:status=>200 }
    end
  end
end
