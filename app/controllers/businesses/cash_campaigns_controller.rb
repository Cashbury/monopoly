class Businesses::CashCampaignsController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :prepare_business

  def new
    @campaign=Campaign.new
    @campaign.engagements.build
    @reward=@campaign.rewards.build
  end

  def create
    @program_type=ProgramType.find_or_create_by_name(:name=>"Marketing")
    @program     =Program.find_or_create_by_business_id_and_program_type_id(:business_id=>@business.id,:program_type_id=>@program_type.id)
    @campaign = @program.campaigns.build(params[:campaign])
    @campaign.measurement_type=MeasurementType.find_or_create_by_name_and_business_id(:name=>@business.currency_code||'USD',:business_id=>@business.id)
    @campaign.start_date = Date.today
    respond_to do |format|
      @reward = @campaign.rewards.first
      if !@reward.money_amount
        @campaign.errors.add(:money_amount,"can't be blank")
        format.html { render :action => "new" }
      else
        if @campaign.save!
          users = User.all
          users.each do |user|
            user.cash_incentive(@business, @reward.money_amount) if user.consumer?
          end
          format.html { 
            redirect_to(business_cash_campaign_path(@business,@campaign), 
                        :notice => 'Campaign was successfully created.')
          }
        else
          format.html { render :action => "new" }
        end
      end
    end
  end

  def show
    @campaign = Campaign.find(params[:id])
    @reward = @campaign.rewards.first
    respond_to do |format|
      format.html
    end
  end

  private

  def prepare_business
    @business = Business.find(params[:business_id])
  end

end
