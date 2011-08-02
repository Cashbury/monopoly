class ServicesController < ApplicationController
  before_filter :authenticate_user!

  def engage
    @user       = User.find(params[:id])
    @engagement = Engagement(params[:engagement_id])

    # Please withdraw from accout
    #render :xml => {}
  end
end
