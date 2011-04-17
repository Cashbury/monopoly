require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "return true when user has account with given campaign" do
    setup do
      @user=Factory.create(:user)
      @campaign=Factory.create(:campaign)
      account_holder=Factory.create(:account_holder,:model_id=>@user.id)
      account=Factory.create(:account,:campaign_id=>@campaign.id,
                                      :account_holder_id=>account_holder.id)
    end
    should "has account with campaign" do
      assert @user.has_account_with_campaign?(@campaign.id)
    end
  end
  
end
