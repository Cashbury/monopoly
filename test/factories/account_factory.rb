Factory.define :account do |acc|
  acc.account_holder Factory.create(:account_holder)
  acc.campaign Factory.create(:campaign)
  acc.measurement_type Factory.create(:measurement_type)
  acc.amount 100
  acc.is_money false
end