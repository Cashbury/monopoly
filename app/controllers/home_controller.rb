class HomeController < ApplicationController
  layout "frontend"

  def index
  end

  def welcome
    @newsletter = Newsletter.new 
    logger.info(@newsletter.inspect)
  end

  def create
    @newsletter = Newsletter.new(params[:newsletter])
    if @newsletter.save
      flash[:notice] = "Thank you registering in beta program !."
      redirect_to "index"
    else
      render :action =>'welcome'
    end
  end

end
