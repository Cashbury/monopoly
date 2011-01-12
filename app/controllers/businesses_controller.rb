class BusinessesController < ApplicationController
  before_filter :authenticate_user!, :except => [:index, :show]
  
  def index
    @businesses = Business.all
    respond_to do |format|
      format.html
      format.xml { render :xml => @businesses }
      format.json { render :text => @businesses.to_json}
    end
  end
  
  def show
    @business = Business.find(params[:id])
    @categories = Category.all
  end
  
  def new
    @business = Business.new
    @categories = Category.all
    3.times { @business.places.build }
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
    @categories = Category.all
    3.times { @business.places.build }
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
