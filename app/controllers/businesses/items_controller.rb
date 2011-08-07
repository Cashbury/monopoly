class Businesses::ItemsController < ApplicationController
 before_filter :authenticate_user!, :require_admin
 before_filter :prepare_business
 
 
  def index
    @items = Item.where(:business_id => @business.id)
  end
  
  def show
    @item = Item.find(params[:id])
  end
  
  def new
    @item = @business.items.build
    @item.build_item_image
  end
 
  def create
    @item = @business.items.build(params[:item])
    if @item.save! && (@item.item_image.nil? || !@item.item_image.need_cropping)
      redirect_to(business_item_url(@business,@item), :notice => 'Item was successfully created.') 
    else
      render :action => 'crop'  
    end
  #rescue
  #  respond_to do |format|
  #    @item.build_item_image if @item.item_image.nil?
  #    format.html { render :action => "new" }
  #    format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
  #  end
  end
 
  def edit
    @item = Item.find(params[:id])
    @item.build_item_image if @item.item_image.nil?
  end
  
  def update
    @item = Item.find(params[:id])
    respond_to do |format|
      if @item.update_attributes!(params[:item])
        format.html { 
          if params[:item][:item_image_attributes][:photo].blank? || !@item.item_image.need_cropping
            redirect_to(business_item_url(@business,@item), :notice => 'item was successfully updated.') 
          else 
            render :action=> 'crop'
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
      end
    end
  rescue
    @item.build_item_image if @item.item_image.nil?
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @item.errors, :status => :unprocessable_entity }
    end
  end
  
  def destroy
    @item = Item.find(params[:id])
    @item.destroy
    flash[:notice] = "Successfully destroyed Item."
    redirect_to business_items_url(@business)
  end
  
  def crop
    
  end
 
  private 
  def prepare_business
    @business = Business.find(params[:business_id])
  end
 
end
