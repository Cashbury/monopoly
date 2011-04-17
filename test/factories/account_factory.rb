Factory.define :account do |acc|
  acc.account_holder_id {Factory(:account_holder).id}
  acc.campaign_id {Factory(:campaign).id}
  acc.measurement_type_id {Factory(:measurement_type).id}
  acc.amount 100
  acc.is_money false
end