class BusinessesController < ApplicationController
  def index
    @businesses = Business.all
  end
  
  def show
    @business = Business.find(params[:id])
  end
  
  def new
    @business = Business.new
  end
  
  def create
    @business = Business.new(params[:business])
    if @business.save
      flash[:notice] = "Successfully created business."
      redirect_to @business
    else
      render :action => 'new'
    end
  end
  
  def edit
    @business = Business.find(params[:id])
  end
  
  def update
    @business = Business.find(params[:id])
    if @business.update_attributes(params[:business])
      flash[:notice] = "Successfully updated business."
      redirect_to @business
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @business = Business.find(params[:id])
    @business.destroy
    flash[:notice] = "Successfully destroyed business."
    redirect_to businesses_url
  end
end
