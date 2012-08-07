xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8"
xml.receipt do
  customer = User.find(@receipt.customer_id)
  business = Business.find(@receipt.business_id)                      
  customer_type = customer.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
  xml.customer_name customer.full_name
  xml.customer_type customer_type
  xml.customer_image_url URI.escape(customer.email.match(/facebook/) ? "https://graph.facebook.com/#{customer.id}/picture" : "/images/user-default.jpg")
  xml << render(:partial => "users/shared/receipt_details", :locals => { :receipt => @receipt })
end