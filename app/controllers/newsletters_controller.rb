class NewslettersController < ApplicationController
  layout "frontend"
  before_filter :authenticated_user! , :only=>[:show, :edit, :update , :destroy]
  
  def index
    @newsletters = Newsletter.all
  end

  def show
    @newsletter = Newsletter.find(params[:id])
  end

  def new
    @newsletter = Newsletter.new
  end

  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      flash[:notice] = "Thank you registering in beta program !."
      redirect_to "index"
    else
      render :action => "new"
    end
  end

  def edit
    @newsletter = Newsletter.find(params[:id])
  end

  def update
    @newsletter = Newsletter.find(params[:id])
    if @newsletter.update_attributes(params[:newsletter])
      flash[:notice] = "Successfully updated newsletter."
      redirect_to newsletter_url
    else
      render :action => 'edit'
    end
  end

  def destroy
    @newsletter = Newsletter.find(params[:id])
    @newsletter.destroy
    flash[:notice] = "Successfully destroyed newsletter."
    redirect_to newsletters_url
  end
end
