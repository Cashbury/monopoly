class HomeController < ApplicationController
  layout "frontend"

  def index
  end

  def welcome
    @follower = Follower.new 
    logger.info(@follower.inspect)
  end

  def create
    @follower = Follower.new(params[:follower])
    if @follower.save
      flash[:notice] = "Thank you registering in beta program !."
      redirect_to "index"
    else
      render :action =>'welcome'
    end
  end

end