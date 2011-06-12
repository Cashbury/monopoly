Factory.define :program do |p|
  p.program_type_id {Factory(:program_type).id}
  p.business_id {Factory(:business).id}
end