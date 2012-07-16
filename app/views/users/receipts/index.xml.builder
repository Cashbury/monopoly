xml.instruct! :xml, :version => "1.0", :encoding => "UTF-8" 
xml.pending_receipts do
  xml << render(:partial => "receipt_details")
end