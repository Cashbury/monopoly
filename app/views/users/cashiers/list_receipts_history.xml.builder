xml.instruct! :xml, :version=>"1.0", :encoding=>"UTF-8"
xml.cashier_receipts do
  @dates.each do |date|
    xml.day do
      xml.date date
      sub_receipts = @all_receipts.select {|r| r.date_time.to_date == date}
      xml.receipts do
        sub_receipts.each do |receipt|
          xml.receipt do
            customer = User.find(receipt.customer_id)
            business = Business.find(receipt.business_id)                      
            customer_type = customer.engaged_with_business?(business) ? "Returning Customer" : "New Customer"
            xml.customer_name customer.full_name
            xml.customer_type customer_type
            xml.customer_image_url URI.escape(customer.email.match(/facebook/) ? "https://graph.facebook.com/#{customer.id}/picture" : "/images/user-default.jpg")
            xml << render(:partial => "users/shared/receipt_details", :locals => { :receipt => receipt })
          end
        end
      end
    end
  end
end