class HomeController < ApplicationController
  layout "frontend"

  def index
  end

  def welcome
    @title = "Home"
    flash[:notice] = "have to fix this"

    render :layout=>"home"
  end

end
