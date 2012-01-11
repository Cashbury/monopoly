require 'spec_helper'

describe User do
  let(:subject) { Factory(:consumer) }

  it "should #auto_enroll_at a business with a money program" do
    business = Factory(:business)
    place = Factory(:place, :business => business)
    business.create_money_program!

    subject.auto_enroll_at([place])
    subject.programs.should include(business.money_program)
  end
end
