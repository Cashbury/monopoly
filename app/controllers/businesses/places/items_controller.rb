class Businesses::Places::ItemsController < ApplicationController
 before_filter :prepare_business_and_place
 
 
 def index
    @items = @place.items
  end
  
  def show
    @item = Item.find(params[:id])
  end
 
 def new
  @item = @place.items.build
 end
 
 def create
    @item = @place.items.build(params[:item])
    @place.items << @item
    unless params[:upload][:photo].blank?
      image =  ENABLE_DELAYED_UPLOADS ? TmpImage.new() : ItemImage.new()
      image.upload_type = "ItemImage"
      image.uploadable = @item
      image.photo = params[:upload][:photo]
    end
    if @item.save and @place.save
      image.save! if image
      flash[:notice] = "Successfully created Item."
      redirect_to business_place_item_url(@business,@place,@item)
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
      redirect_to  business_place_item_url(@business,@place,@item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    if @item.business_id.nil?
      @item.destroy 
    else
      ItemPlace.where(:place_id=>@place.id , :item_id => @item.id).first.destroy
    end 
    flash[:notice] = "Successfully destroyed Item."
    redirect_to business_place_items_url(@business,@place)
  end
  
 
 private 
 def prepare_business_and_place
   @business = Business.find(params[:business_id])
   @place    = Place.find(params[:place_id])
 end
 
end