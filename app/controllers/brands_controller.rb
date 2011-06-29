class BrandsController < ApplicationController
	before_filter :authenticate_user!, :require_admin
  # GET /brands
  # GET /brands.xml
  def index
    @brands = Brand.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @brands }
    end
  end

  # GET /brands/1
  # GET /brands/1.xml
  def show
    @brand = Brand.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/new
  # GET /brands/new.xml
  def new
    @brand = Brand.new
    @brand.build_brand_image
    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
    @brand.build_brand_image if @brand.brand_image.nil?
  end

  # POST /brands
  # POST /brands.xml
  def create
    @brand = Brand.new(params[:brand])
    @brand.user_id = current_user.id
    respond_to do |format|
      format.html {       
        if @brand.save! && (@brand.brand_image.nil? || !@brand.brand_image.need_cropping)
          redirect_to(@brand, :notice => 'Brand was successfully created.') 
        else
          render :action => 'crop'  
        end
      }
      format.xml  { render :xml => @brand, :status => :created, :location => @brand }
    end
  rescue
    respond_to do |format|
      format.html { render :action => "new" }
      format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
    end 
  end

  # PUT /brands/1
  # PUT /brands/1.xml
  def update
    @brand = Brand.find(params[:id])
    @brand.user_id = current_user.id
    respond_to do |format|
      if @brand.update_attributes!(params[:brand])
        format.html { 
          if params[:brand][:brand_image_attributes][:photo].blank? || !@brand.brand_image.need_cropping
            redirect_to(@brand, :notice => 'Brand was successfully updated.') 
          else 
            render :action=> 'crop'
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
      end
    end
  rescue
    respond_to do |format|
      format.html { render :action => "edit" }
      format.xml  { render :xml => @brand.errors, :status => :unprocessable_entity }
    end
  end

  # DELETE /brands/1
  # DELETE /brands/1.xml
  def destroy
    @brand = Brand.find(params[:id])
    @brand.destroy

    respond_to do |format|
      format.html { redirect_to(brands_url) }
      format.xml  { head :ok }
    end
  end
  
  def crop
    
  end
end
