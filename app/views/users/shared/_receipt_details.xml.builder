business = Business.where(:id => receipt.business_id).first
brand = business.try(:brand)
place = Place.find(receipt.place_id) unless receipt.place_id.nil?
xml.id receipt.receipt_id
if place.present?
  xml.date_time receipt.date_time.in_time_zone(place.time_zone)
else
  xml.date_time receipt.date_time
end
if receipt.state == "refunded"
  xml.state           receipt.state || "succeeded"
  xml.amount_refunded receipt.tip.to_f + receipt.amount_rungup.to_f
  xml.amount_refunded_minus_credit receipt.credit_used
end
xml.transaction_id    receipt.transaction_id if receipt.transaction_id.present?
xml.transaction_group_id    receipt.transaction_group_id if receipt.transaction_group_id.present?  
xml.transaction_type  receipt.transaction_group_id.present? ? "Spend"  : receipt.transaction_type
xml.brand_name        receipt.brand_name
xml.brand_image_fb    brand.try(:brand_image).nil? ? nil : URI.escape(brand.brand_image.photo.url(:thumb))
xml.business_name     business.try(:name)
xml.place_name        receipt.place_name      
xml.currency_symbol   business.try(:currency_symbol)
xml.currency_code     business.try(:currency_code)
xml.money_program do
  xml.amount_rungup     receipt.amount_rungup
  xml.tip               receipt.tip
  xml.total             receipt.tip.to_f + receipt.amount_rungup.to_f      
  xml.credit_used       receipt.credit_used
  xml.cash_out          (receipt.tip.to_f + receipt.amount_rungup.to_f) - receipt.credit_used.to_f
end
xml.marketing_program do 
  if receipt.cash_reward.present?
    xml.cash_reward       receipt.cash_reward
    xml.earned_points     receipt.earned_points
    xml.current_credit    receipt.current_credit      
    xml.remaining_credit  receipt.remaining_credit
    xml.unlocked_credit   receipt.unlocked_credit
    xml.progress_percent  (receipt.current_credit.to_f / ( receipt.current_credit.to_f + receipt.remaining_credit.to_f)) * 100
  end
  xml.cashbury_act_balance receipt.cashbury_act_balance
  xml.fb_engagement_msg receipt.fb_engagement_msg                   
  log_group = LogGroup.where(:id => receipt.log_group_id).first
  if log_group.present?
    logs = log_group.get_receipt_engagements 
    xml.engagements do       
      logs.each_with_index do |log,i|
        xml.engagement do  
          xml.current_balance log.current_balance
          xml.amount          log.amount
          xml.campaign_id log.campaign_id
          xml.title           log.title
          xml.quantity        log.quantity
        end
      end
    end
  end
end  