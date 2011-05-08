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
    if @item.save
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
    if @item.update_attributes(params[:item])
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