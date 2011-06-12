require 'test_helper'

class RewardTest < ActiveSupport::TestCase
  def test_should_not_be_valid
    assert !Reward.new.valid?
  end
  
  context "Claiming a reward" do
    setup do
      places=[]
      @user=Factory.create(:user)
      business=Factory.create(:business)
      country=Factory.create(:country,:name=>"Egypt",:abbr=>"EG")
      city=Factory.create(:city,:name=>"Alexandria",:lat=>"31.2135",:lng=>"29.9443",:country=>country)
      address=Factory.create(:address,:city_id=>city.id,:country_id=>country.id)
      @place=Factory.create(:place,:business_id=>business.id,:address_id=>address.id)
      places << @place
      program=Factory.create(:program,:business_id=>business.id)
      @campaign=Factory.create(:campaign,:program_id=>program.id,:initial_amount=>10)
      @reward=Factory.create(:reward,:campaign_id=>@campaign.id)
      @user.auto_enroll_at(places)
      @account=@campaign.user_account(@user)
      @action=Factory.create(:action,:name=>"Redeem")
    end
    should "decrement user's account and create a log" do
      total_logs=Log.count
      assert_equal @account.amount, @campaign.initial_amount
      @reward.is_claimed_by(@user,@account,@place.id,@place.lat,@place.long)
      assert_equal @account.amount, @campaign.initial_amount - @reward.needed_amount
      assert_equal Log.count, total_logs +1
    end
  end
end
