class Users::ReceiptsController < Users::BaseController
  def index
    all_receipts=current_user.receipts
                             .joins([:business=>:brand,:place=>:address])
                             .select("receipts.spend_campaign_id as campaign_id,receipts.log_group_id,receipts.amount,receipts.business_id, receipts.place_id, receipts.receipt_text,receipts.receipt_type, receipts.user_id, receipts.transaction_id, receipts.created_at as date_time, places.name as place_name, brands.name as brand_name")
    result={}
    result[:receipts]=[]
    all_receipts.each_with_index do |receipt,index|
      result[:receipts][index]=receipt.attributes
      result[:receipts][index][:currency_symbol]=Business.find(receipt.business_id).currency_symbol
      log_group=LogGroup.where(:id=>receipt.log_group_id).first
      if log_group.present?
        result[:receipts][index][:engagements]=[]
        logs=log_group.logs.joins(:engagement=>[:item,:campaign]).select("campaigns.id as campaign_id,logs.gained_amount as amount, engagements.name as title, logs.frequency as quantity")
        logs.each_with_index do |log,i|
          result[:receipts][index][:engagements][i]=log.attributes
        end
      end
    end
    respond_to do |format|       
      format.xml { render :xml => result,:status=>200 }
    end
  end
end
