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
    if @item.save and @place.save
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
    if @item.update_attributes(params[:item])
      flash[:notice] = "Successfully updated Item."
      redirect_to  business_place_item_url(@business,@place,@item)
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed Item."
    redirect_to business_place_items_url(@business,@place)
  end
  
 
 private 
 def prepare_business_and_place
   @business = Business.find(params[:business_id])
   @place    = Place.find(params[:place_id])
 end
 
end