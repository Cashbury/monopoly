Factory.define :measurement_type do |mt|
  mt.sequence(:name) {|n| "MeasurementType#{n}" }
end