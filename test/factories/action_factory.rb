Factory.define :action do |action|
  action.name "Engagement"
  action.transaction_type_id {Factory(:transaction_type).id}
end