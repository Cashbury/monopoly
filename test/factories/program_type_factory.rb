Factory.define :program_type do |pt|
  pt.sequence(:name) {|n| "Type#{n}" }
end