xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
xml.customer_receipts do
  @all_receipts.each do |receipt|
    xml.receipt do
      business= Business.find(receipt.business_id) 
      brand= business.brand
      xml.current_balance receipt.current_balance
      xml.earned_points   receipt.earned_points
      xml.spend_money     receipt.spend_money
      xml.fb_engagement_msg receipt.fb_engagement_msg
      xml.receipt_text    receipt.receipt_text
      xml.receipt_type    receipt.receipt_type
      xml.transaction_id  receipt.transaction_id
      xml.date_time       receipt.date_time
      xml.place_name      receipt.place_name
      xml.brand_name      receipt.brand_name
      xml.currency_symbol Business.find(receipt.business_id).currency_symbol
      xml.brand_image_fb  brand.try(:brand_image).nil? ? nil : URI.escape(brand.brand_image.photo.url(:thumb))          
      log_group=LogGroup.where(:id=>receipt.log_group_id).first
      if log_group.present?
        logs=log_group.get_receipt_engagements 
        xml.engagements do       
          logs.each_with_index do |log,i|
            xml.engagement do  
              xml.current_balance log.current_balance
              xml.amount          log.amount
              xml.title           log.title
              xml.quantity        log.quantity
            end
          end
        end
      end
    end
  end
end
