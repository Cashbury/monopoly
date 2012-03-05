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


  it "should be a single use if code_type is false" do
    qr_code = QrCode.create;
    qr_code.code_type = false;
    qr_code.single_use?.should be true
  end

  it "should be a multi use if code_type is true" do
    qr_code = QrCode.create;
    qr_code.code_type = true;
    qr_code.multi_use?.should be true
  end

  subject { Factory.create(:user) }

  it "should reissue new Qrcode" do
    old_qr_code = subject.qr_code
    subject.qr_code.reissue
    subject.reload
    old_qr_code.id.should_not == subject.qr_code.id
  end

  it "deactivate method should set status to 0" do
    subject.qr_code.status = true
    subject.qr_code.deactivate
    subject.qr_code.status.should be false
  end

  it "should be deactivated after reissuing a new one" do
    old_qr_id = subject.qr_code.id
    subject.qr_code.status = true
    subject.qr_code.save!
    subject.qr_code.reissue
    QrCode.find(old_qr_id).status.should be false
  end

  it "after reissueing new qrcode code_type should be the same of the old qrcode" do
    [true,false].each do |old_code_type|
      subject.qr_code.code_type = old_code_type
      subject.qr_code.reissue
      subject.qr_code.reload
      subject.qr_code.code_type.should be old_code_type
    end
  end


end
