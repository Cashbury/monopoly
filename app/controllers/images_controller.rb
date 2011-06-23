class ImagesController < ApplicationController
  before_filter :authenticate_user!, :require_admin
	def update
    @image = Image.find params[:id]
    if @image.update_attributes params[:image]
      flash[:notice] = 'Image was successfully updated.'
      redirect_to brand_path(@image.uploadable)
    end
  end
end
