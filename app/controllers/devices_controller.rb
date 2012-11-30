class DevicesController < ApplicationController

  before_filter :authenticate_user!, :require_admin
  
  def authorize
    @device = Device.find(params[:id])
    @device.update_attribute(:active, true)
  end

  def deauthorize
    @device = Device.find(params[:id])
    @device.update_attribute(:active, false)
  end
end