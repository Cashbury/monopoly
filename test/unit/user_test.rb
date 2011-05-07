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
  
  context "auto enroll user at particular places" do
    setup do
      @user=Factory.create(:user)
      @places=[]
      3.times do |n|
        business=Factory.create(:business)
        place=Factory.create(:place,:business_id=>business.id)
        @places << place
        program=Factory.create(:program,:business_id=>business.id)
        campaign=Factory.create(:campaign,:program_id=>program.id)
      end
      @user.auto_enroll_at(@places)
    end
    
    should "create accounts for that user at places' campaigns" do
      assert_equal @places.count, 3
      assert_equal Campaign.count, 3
      assert_equal @user.account_holder.accounts.size,3
      Campaign.all.each do |campaign|
        assert @user.has_account_with_campaign?(campaign.id)
      end
    end
  end 
  
  context "test snapping a qr code" do
    setup do
      @user=Factory.create(:user)
      @place=Factory.create(:place)
      program=Factory.create(:program,:business_id=>@place.business.id)
      @campaign=Factory.create(:campaign,:program_id=>program.id,:initial_amount=>10)
      @engagement=Factory.create(:engagement,:campaign_id=>@campaign.id,:amount=>5)
      @qr_code=Factory.create(:qr_code,:associatable_id=>@engagement.id)
      @action=Factory.create(:action)
      @places=[];@places << @place
      @user.auto_enroll_at(@places)
    end
    
    should "increment user's account created within the campaign by engagement's amount" do
      total_logs=Log.count
      @user.snapped_qrcode(@qr_code,@place.id,@place.lat,@place.long)
      transaction=Transaction.last
      assert_equal @user.account_holder.accounts.where(:campaign_id=>@campaign.id).first.amount,15
      assert_equal Log.count,total_logs+1
      assert_equal transaction.after_fees_amount, @engagement.amount
      assert_equal transaction.transaction_type, @action.transaction_type
      assert_equal transaction.from_account_balance_after, @campaign.business_account.amount
      assert_equal transaction.to_account_balance_after, @campaign.user_account(@user).amount
      assert !QrCode.find(@qr_code.id).status #has been scanned if single use
    end
  end
end
