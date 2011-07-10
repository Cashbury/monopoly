class UsersManagementController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :list_places_and_bizs, :only=>[:new,:create,:edit,:update]
  
  def index
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @users=User.with_account_at_large.with_code.terms(params[:title]).paginate(:page => @page,:per_page => User::per_page )
  end

  def new
    @user=User.new
    @user.build_mailing_address
    @user.build_billing_address
  end
  
  def create
    @user= User.new(params[:user])
    @user.employees.build(:role_id=>params[:user][:role_id],:business_id=>params[:business_id])    
    respond_to do |format|
      if @user.save
        if params[:place_id].present?
          @user.places << Place.find(params[:place_id]) 
          @user.save!
        end
        format.html { redirect_to(users_management_index_path, :notice => 'User was successfully created.') }
        format.xml  { head :ok }
      else
        @user.build_mailing_address unless @user.mailing_address.present?
        @user.build_billing_address unless @user.billing_address.present?
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
  end

  def update
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_management_index_path) }
      format.xml  { head :ok }
    end
  end
  
  def check_role
    role=Role.find(params[:role_id])
    render :text=>role.require_business?
  end
  
  def update_places
    @places = Place.where(:business_id=> params[:id])
    respond_to do |format|
      format.js
    end
  end
  
  def update_cities
    @cities = City.where(:country_id=> params[:id])
    @selector_id=params[:selector_id]
    respond_to do |format|
      format.js
    end
  end
  
  def check_attribute_availability
    if User.exists?(["LOWER(#{params[:attribute_name]}) = ?", params[:attribute_value].mb_chars.downcase])
      respond_to do |format|
        format.js { render :text => 'Not available, choose another one', :status => 500 }
      end
    else
      respond_to do |format|
        format.js { render :text => "Congratulaions, it's available!", :status => 200 }
      end
    end
  end
  
  def list_places_and_bizs
    @businesses=Business.all
    @places=Place.all
  end
    
end
