class Businesses::ItemsController < ApplicationController
 before_filter :prepare_business
 
 
 def index
    @items = Item.where(:business_id => @business.id)
  end
  
  def show
    @item = Item.find(params[:id])
  end
 
 def new
  @item = Item.new
 end
 
 def create
    @item = Item.new(params[:item])
    unless params[:upload][:photo].blank?
      image =  ENABLE_DELAYED_UPLOADS ? TmpImage.new() : ItemImage.new()
      image.upload_type = "ItemImage"
      image.uploadable = @item
      image.photo = params[:upload][:photo]
    end
    if @item.save
      image.save! if image
      flash[:notice] = "Successfully created Item."
      redirect_to business_item_url(@business,@item)
    else
      render :action => 'new'
    end
 end
 
 def edit
    @item = Item.find(params[:id])
  end
  
  def update
    @item = Item.find(params[:id])
    unless params[:upload][:photo].blank?
      @item.item_image.try(:destroy)
      image =  ENABLE_DELAYED_UPLOADS ? TmpImage.new() : ItemImage.new()
      image.upload_type = "ItemImage"
      image.uploadable = @item
      image.photo = params[:upload][:photo]
    end
    if @item.update_attributes(params[:item])
      image.save! if image
      flash[:notice] = "Successfully updated Item."
      redirect_to  business_item_url(@business,@item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed Item."
    redirect_to business_items_url(@business)
  end
  
 
 private 
 def prepare_business
   @business = Business.find(params[:business_id])
 end
 
end