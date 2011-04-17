Factory.define :measurement_types do |mt|
  mt.sequence(:name) {|n| "MeasurementType#{n}" }
end