require 'spec_helper'

describe QrCode do

  it "should create qr_code given valid attributes" do
    Factory.build(:qr_code).should be_valid
  end

  it "should create multiple use qr code for campaign" do
    campaign = Factory.create(:campaign)
    engagement = Factory.create(:engagement)
    campaign.engagements << engagement
    qr_code = QrCode.create_for_campaign(campaign)
    qr_code.code_type.should == true # QrCode::MULTI_USE
    qr_code.associatable.should == engagement
  end

end
