xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
xml.cashier_receipts do
  @required_dates_array.each do |date|
    xml.day do
      xml.date date
      sub_receipts=@all_receipts.select {|r| r.date_time.to_date == date.to_date}
      xml.receipts do
        sub_receipts.each do |receipt|
          xml.receipt do
            customer= User.find(receipt.customer_id) 
            business= Business.find(receipt.business_id) 
            brand= business.brand 
            customer_type= customer.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
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
            xml.customer_name   customer.full_name
            xml.customer_type   customer_type
            xml.customer_image_url URI.escape(customer.email.match(/facebook/) ? "https://graph.facebook.com/#{customer.id}/picture" : "/images/user-default.jpg")
            log_group=LogGroup.where(:id=>receipt.log_group_id).first
            if log_group.present?
              logs=log_group.get_receipt_engagements 
              xml.engagements do       
                logs.each_with_index do |log,i|
                  xml.engagement do  
                    xml.current_balance log.current_balance
                    xml.amount          log.amount
                    xml.campaign_id     log.campaign_id
                    xml.title           log.title
                    xml.quantity        log.quantity
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
