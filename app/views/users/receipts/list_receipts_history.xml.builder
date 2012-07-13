xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8" 
xml.customer_receipts do
  @all_receipts.uniq.each do |receipt|
    xml.receipt do
      business = Business.where(:id => receipt.business_id).first
      brand = business.try(:brand)
      place = Place.find(receipt.place_id) unless receipt.place_id.nil?
      xml.current_credit    receipt.current_credit
      xml.credit_used       receipt.credit_used
      xml.unlocked_credit   receipt.unlocked_credit
      xml.cashbury_act_balance receipt.cashbury_act_balance
      xml.remaining_credit  receipt.remaining_credit
      xml.earned_points     receipt.earned_points
      xml.spend_money       receipt.spend_money
      xml.cash_reward       receipt.cash_reward
      xml.fb_engagement_msg receipt.fb_engagement_msg
      xml.receipt_text      receipt.receipt_text
      xml.receipt_type      receipt.receipt_type
      xml.transaction_id    receipt.transaction_id if receipt.transaction_id.present?
      xml.transaction_group_id    receipt.transaction_group_id if receipt.transaction_group_id.present?
      if place.present?
        xml.date_time receipt.date_time.in_time_zone(place.time_zone)
      else
        xml.date_time receipt.date_time
      end      
      xml.place_name        receipt.place_name
      xml.brand_name        receipt.brand_name
      xml.currency_symbol   business.try(:currency_symbol)
      xml.currency_code     business.try(:currency_code)
      xml.brand_image_fb    brand.try(:brand_image).nil? ? nil : URI.escape(brand.brand_image.photo.url(:thumb))          
      log_group = LogGroup.where(:id => receipt.log_group_id).first
      if log_group.present?
        logs = log_group.get_receipt_engagements 
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
