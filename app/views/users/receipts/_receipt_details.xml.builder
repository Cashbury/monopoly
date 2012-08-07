@all_receipts.uniq.each do |receipt|
  xml.receipt do
    xml << render(:partial => "users/shared/receipt_details", :locals => { :receipt => receipt })
  end
end