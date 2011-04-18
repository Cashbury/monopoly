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
      @place=Factory.create(:place,:business_id=>business.id)
      places << @place
      program=Factory.create(:program,:business_id=>business.id)
      @campaign=Factory.create(:campaign,:program_id=>program.id,:initial_points=>10)
      @reward=Factory.create(:reward,:campaign_id=>@campaign.id)
      @user.auto_enroll_at(places)
      @account=@user.account_holder.accounts.where(:campaign_id=>@campaign.id).first
      
    end
    should "decrement user's account and create a log" do
      total_logs=Log.count
      assert_equal @account.amount, @campaign.initial_points
      @reward.is_claimed_by(@user,@account,@place.id,@place.lat,@place.long)
      assert_equal @account.amount, @campaign.initial_points - @reward.needed_amount
      assert_equal Log.count, total_logs +1
    end
  end
end
