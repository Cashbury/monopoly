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

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @brand }
    end
  end

  # GET /brands/1/edit
  def edit
    @brand = Brand.find(params[:id])
  end

  # POST /brands
  # POST /brands.xml
  def create
    @brand = Brand.new(params[:brand])
    @brand.user_id = current_user.id
    params[:upload] ||= {}
    unless params[:upload][:photo].nil?
      image =  ENABLE_DELAYED_UPLOADS ? TmpImage.new() : BrandImage.new()
      image.upload_type = "BrandImage"
      image.uploadable = @brand
      image.photo = params[:upload][:photo]
    end
    Brand.transaction do
      @brand.save!
      image.save! if image
    end
    respond_to do |format|
      format.html { 
        if params[:upload][:photo].blank?
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
    params[:upload] ||= {}
    unless params[:upload][:photo].nil?
      @brand.brand_image.try(:destroy)
      image =  ENABLE_DELAYED_UPLOADS ? TmpImage.new() : BrandImage.new()
      image.upload_type = "BrandImage"
      image.uploadable = @brand
      image.photo = params[:upload][:photo]
      @brand.brand_image=image
      @brand.save!
    end
    respond_to do |format|
      if @brand.update_attributes!(params[:brand])
        format.html { 
          if params[:upload][:photo].blank?
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
 #def resize_uploaded_image_for_cropping(image_field_params)
 #   @upload_io = image_field_params
 #   @filename = @upload_io.original_filename
 #   @filepath = Rails.root.join('public', 'images', @filename)
 #   File.open(@filepath) do |file|
 #     file.write(image_io.read)
 #   end
 #   @original = Magick::Image.read(@filepath)
 #   @thumbnail = @original.resize_to_fit 75 75
 #   @thumbnail.write(Rails.root.join('public', 'images', 'tmp_' + filename)
 # end
end
