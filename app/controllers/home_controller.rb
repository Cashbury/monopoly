class HomeController < ApplicationController
  layout "frontend"

  def index
  end

  def welcome
    @title = "Home"

    render :layout=>"home"
  end

end
