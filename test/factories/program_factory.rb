Factory.define :program do |p|
  p.program_type Factory.create(:program_type)
  p.business Factory.create(:business)
end