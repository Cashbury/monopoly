class DevicesController < ApplicationController

  before_filter :authenticate_user!, :require_admin
  
  def authorize
    @device = Device.find(params[:id])
    @device.activate!
  end

  def deauthorize
    @device = Device.find(params[:id])
    @device.deactivate!
  end
end