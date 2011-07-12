class UsersManagementController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :list_places_and_bizs, :only=>[:new,:create,:edit,:update]
  
  def index
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @users=User.with_account_at_large.with_code.terms(params[:title]).order("users.created_at DESC").paginate(:page => @page,:per_page => User::per_page )
  end

  def new
    @user=User.new
    @user.build_mailing_address
    @user.build_billing_address
    @total=LegalType.count
  end
  
  def create
    @user= User.new(params[:user])
    @user.employees.build(:role_id=>params[:user][:role_id],:business_id=>params[:business_id])    
    if params[:user][:mailing_address_attributes].present?
      address=Address.create(params[:user][:mailing_address_attributes])
      @user.mailing_address_id=address.id
    end
    if params[:user][:billing_address_attributes].present?
      address=Address.create(params[:user][:billing_address_attributes])
      @user.billing_address_id=address.id
    end
    if params[:birth][:day].present? and params[:birth][:month].present? and params[:birth][:year].present?
      @user.dob=Date.civil(params[:birth][:year].to_i,params[:birth][:month].to_i,params[:birth][:day].to_i)     
    end
    respond_to do |format|
      if @user.save
        @user.send_confirmation_instructions if @user.persisted? 
        unless params[:legal_ids].empty? and params[:legal_types].empty?
          params[:legal_types].each_with_index do |legal_type_id, index|
            LegalId.create(:id_number=>params[:legal_ids][index],:associatable_id=>@user.id,:associatable_type=>"User",:legal_type_id=>legal_type_id)
          end
        end
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
  def resend_password
    user = User.find_by_email(params[:user][:email])
    user.send_reset_password_instructions if user && user.persisted?    
    respond_to do |format|
      format.html { 
       if user.errors.empty?
    			redirect_to(users_management_path(user), :notice=>"Reset password instructions have been re-sent to #{user.full_name}")
    		else    		  
      		redirect_to(users_management_path(user),:error=>user.full_messages.join(','))
    		end 
      }
    end
  end
  
  def send_confirmation_email
    user = User.find_by_email(params[:user][:email])
    user.send_confirmation_instructions if user && user.persisted?    
    respond_to do |format|
      format.html { 
       if user.errors.empty?
    			redirect_to(users_management_path(user), :notice=>"Confirmation Email has been resend to #{user.full_name}")
    		else    		  
      		redirect_to(users_management_path(user),:error=>user.full_messages.join(','))
    		end 
      }
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
  
  def suspend_user
    user=User.find(params[:id])
    user.suspend
    render :text=>user.active ? "Active" : "Inactive"
  end
  
  def reactivate_user
    user=User.find(params[:id])
    user.activate
    render :text=>user.active ? "Active" : "Inactive"
  end
  
  def reissue_code
    user=User.find(params[:id])
    qr_code=user.qr_code
    @new_qrcode=user.issue_qrcode(current_user.id, qr_code.size, qr_code.code_type)
    qr_code.update_attributes({:status=>false,:associatable_id=>nil,:associatable_type=>nil})
    render :text=>(render_to_string :partial=> "user_code_container")
  end
  
  def list_businesses_by_program_type
    #@results=Business.joins([[:programs=>[:program_type,[:accounts=>:account_holder]]],"LEFT OUTER JOIN countries ON countries.id=businesses.country_id"]).where("programs.program_type_id=#{params[:program_type_id]} and account_holders.model_id=#{params[:uid]} and account_holders.model_type='User'").select("businesses.name as b_name, countries.name as c_name, program_types.name as pt_name, accounts.amount as current_amount, accounts.cumulative_amount as cumulative_amount ")    
    @results=Account.joins([:account_holder, :campaign=>[:program=>[:program_type,[:business=>:country]]]]).where("programs.program_type_id=#{params[:program_type_id]} and account_holders.model_id=#{params[:uid]} and account_holders.model_type='User'").select("businesses.name as b_name, countries.name as c_name, program_types.name as pt_name, (SELECT amount from accounts where business_id=businesses.id and account_holder_id=account_holders.id) as current_amount, (SELECT cumulative_amount from accounts where business_id=businesses.id and account_holder_id=account_holders.id) as cumulative_amount, businesses.id as biz_id, programs.id as p_id, account_holders.model_id as uid ").group("businesses.id")
    render :text=>(render_to_string :partial=> "listing_enrollments_container")
  end
  
  def list_transactions
    @user=User.find(params[:id])
    pt=Program.find(params[:program_id]).program_type
    if pt.name==ProgramType::AS[:marketing]
      @transactions=Log.joins(:transaction=>:transaction_type).where("logs.business_id=#{params[:business_id]} and logs.campaign_id IS NOT NULL and logs.user_id=#{params[:id]}").select("transactions.*,transaction_types.name,transaction_types.fee_amount,transaction_types.fee_percentage,user_id,logs.created_at,place_id,engagement_id")
    else
      @transactions=Log.joins(:transaction=>:transaction_type).where("logs.business_id=#{params[:business_id]} and logs.campaign_id=NULL and logs.user_id=#{params[:id]}").select("transactions.*,transaction_types.name,transaction_types.fee_amount,transaction_types.fee_percentage,user_id,logs.created_at,place_id,engagement_id")
    end
    respond_to do |format|
      format.html
    end
  end
  
  def list_places_and_bizs
    @businesses=Business.all
    @places=Place.all
  end
    
end
