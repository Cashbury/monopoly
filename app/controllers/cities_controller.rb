class CitiesController < ApplicationController
  before_filter :authenticate_user!

  # GET /cities
  # GET /cities.xml
  def index
    respond_to do |format|

      format.html{
        @cities= City.paginate :page=>params[:page], :order => "name asc" , :conditions=> search
      }
      format.xml{
        cities_by_name
      }
      format.js do
        cities_by_name
        @cities = @cities.map {|city| {:id=>city.id, :name=>city.name}}
        render :json , @cities
      end
    end
  end

  # GET /cities/1
  # GET /cities/1.xml
  def show
    @city = City.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/new
  # GET /cities/new.xml
  def new
    @city = City.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @city }
    end
  end

  # GET /cities/1/edit
  def edit
    @city = City.find(params[:id])
  end

  # POST /cities
  # POST /cities.xml
  def create
    @city = City.new(params[:city])

    respond_to do |format|
      if @city.save
        format.html { redirect_to(@city, :notice => 'City was successfully created.') }
        format.xml  { render :xml => @city, :status => :created, :location => @city }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /cities/1
  # PUT /cities/1.xml
  def update
    @city = City.find(params[:id])
    debugger
    respond_to do |format|
      if @city.update_attributes(params[:city])
        format.html { redirect_to(@city, :notice => 'City was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @city.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /cities/1
  # DELETE /cities/1.xml
  def destroy
    @city = City.find(params[:id])
    @city.destroy

    respond_to do |format|
      format.html { redirect_to(cities_url) }
      format.xml  { head :ok }
    end
  end


  def vote
    @city = City.find(params[:id])
    if(params[:like].downcase =="down")
      current_user.unflag(@city, :like)
    else
      current_user.flag(@city, :like)
    end
    render :nothing=>true
  end

  def votes
    @city = City.find(params[:id])
    render :json=> [:id=>@city.id, :name=>@city.name,:like_count=>@city.flaggings.size() ]
  end

  private #================

  def cities_by_name
    @cities = City.where(:name=>params[:name].capitalize).joins(:country) if params[:name].present?
  end

  def search
    conditions = []
    conditions = ["name like ?", "%#{params[:name]}%"] unless params[:name].blank?
  end

end
