class FollowersController < ApplicationController
  layout "frontend"
  
  def index
  end

  def show
    @follower = Follower.find(params[:id])
  end

  def new
    @follower = Follower.new
  end

  def create
    @follower = Follower.new(params[:follower])
    if @follower.save
      flash[:notice] = "Thank you registering in beta program !."
      redirect_to :action=>'index'
    else
      render :action => "new"
    end
  end

  def edit
    @follower = Follower.find(params[:id])
  end

  def update
    @follower = Follower.find(params[:id])
    if @follower.update_attributes(params[:follower])
      flash[:notice] = "Successfully updated follower."
      redirect_to follower_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @follower = Follower.find(params[:id])
    @follower.destroy
    flash[:notice] = "Successfully destroyed follower."
    redirect_to follower_url
  end
end
