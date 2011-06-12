require 'test_helper'

class CampaignTest < ActiveSupport::TestCase
  context "testing campaigns" do
    setup do
      @campaign=Factory.create(:campaign)
      @business = @campaign.program.business
    end
    should "create business account to this campaign" do
      @account = @campaign.accounts[0]
      @account_holder = @account.account_holder
      
      assert_equal  @account_holder.model_type , @business.class.to_s
      assert_equal  @account_holder.model_id , @business.id
      assert_equal  @account.campaign_id , @campaign.id
   end
  end
end
