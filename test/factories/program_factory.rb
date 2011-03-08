Factory.define :program do |pgm|
  pgm.sequence(:name) {|n| "pgm#{n}" }
  pgm.auto_enroll true
  pgm.start_date Date.today
  pgm.end_date Date.today
  pgm.initial_points 10
  pgm.max_points 100
end