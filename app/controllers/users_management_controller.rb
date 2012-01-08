class UsersManagementController < ApplicationController
  before_filter :authenticate_user!, :require_admin
  before_filter :list_places_and_bizs, :only=>[:new,:create,:edit,:update]
  @@per_page=20
  
  def index
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @users=User.with_account_at_large.with_code.terms(params[:title]).order("users.created_at DESC").paginate(:page => @page,:per_page => User::per_page )
  end

  def new
    @user=User.new
    @user.build_mailing_address
    @user.build_billing_address
    @total=LegalType.count
    @legal_ids=[]
  end
  
  def create
    @user= User.new(params[:user])
    if params[:user][:roles_list].any?
      params[:user][:roles_list].each do |role_id|
        @user.employees.build(:role_id=>role_id,:business_id=>params[:business_id])    
      end
    end
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
    @user.places << Place.find(params[:place_id])  if params[:place_id].present?
    respond_to do |format|
      if @user.save
        @user.send_confirmation_instructions if @user.persisted? 
        unless params[:legal_ids].empty? || params[:legal_types].empty?
          @user.set_legal_ids(params[:legal_types], params[:legal_ids])
        end
        format.html { redirect_to(users_management_path(@user), :notice => 'User was successfully created.') }
        format.xml  { head :ok }
      else
        @user.build_mailing_address unless @user.mailing_address.present?
        @user.build_billing_address unless @user.billing_address.present?
        @total=LegalType.count
        @legal_ids=[]
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def edit
    @user = User.find(params[:id])
    @user.build_mailing_address unless @user.mailing_address.present?
    @user.build_billing_address unless @user.billing_address.present?
    @total=LegalType.count
    #@roles=@user.roles.select {|role| role.require_business?}
    @roles=@user.employees.select {|employee| employee.business_id.present?}.collect{|e| e.business_id}
    @show_biz_and_place=@roles.any?
    @business_id=@roles.first
    @place_id=@user.places.first.try(:id)
    @legal_ids=@user.legal_ids
  end

  def update
    @user= User.find(params[:id])
    if params[:user][:roles_list].any?
      @user.employees.delete_all
      params[:user][:roles_list].each do |role_id|
        @user.employees.build(:role_id=>role_id,:business_id=>params[:business_id])    
      end
      if params[:place_id].present?
        @user.places.delete_all
        @user.places << Place.find(params[:place_id])
      else
        @user.places.delete_all
      end
    end
    if params[:user][:mailing_address_attributes].present?      
      if @user.mailing_address.present?
        @user.mailing_address.update_attributes(params[:user][:mailing_address_attributes])
      else
        address=Address.create(params[:user][:mailing_address_attributes])
        @user.mailing_address_id=address.id
      end
    end
    if params[:user][:billing_address_attributes].present?      
      if @user.billing_address.present?
        @user.billing_address.update_attributes(params[:user][:billing_address_attributes])
      else
        address=Address.create(params[:user][:billing_address_attributes])
        @user.billing_address_id=address.id
      end
    end
    if params[:birth][:day].present? and params[:birth][:month].present? and params[:birth][:year].present?
      @user.dob=Date.civil(params[:birth][:year].to_i,params[:birth][:month].to_i,params[:birth][:day].to_i)     
    end
    respond_to do |format|
      if @user.update_attributes(params[:user])
        LegalId.delete_all("associatable_id=#{@user.id} and associatable_type='User'")
        unless params[:legal_ids].empty? || params[:legal_types].empty?
          @user.set_legal_ids(params[:legal_types], params[:legal_ids])
        end
        format.html { redirect_to(users_management_path(@user), :notice => 'User was successfully updated.') }
        format.xml  { head :ok }
      else
        @user.build_mailing_address unless @user.mailing_address.present?
        @user.build_billing_address unless @user.billing_address.present?
        @total=LegalType.count
        @role_id=@user.roles.try(:first).try(:id)
        @legal_ids=@user.legal_ids
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def show
    @user = User.find(params[:id])
    @results=Account.listing_user_enrollments(params[:id],ProgramType.find_by_name(ProgramType::AS[:marketing]).try(:id))    
    @recent_transactions=Log.get_recent_transactions(params[:id])
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end
  
  #View All transactions at user's code
  def all_qr_codes_transactions
    @user = User.find(params[:id])
    @qr_code= @user.qr_code
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @all_transactions=Log.all_qrcodes_transactions(params[:id])
                         .paginate(:page => @page,:per_page =>@@per_page )
    render :layout=>false                         
  end
  
  #View details at qrcode transaction
  def view_tx_details
    @user = User.find(params[:id])
    @result=Log.view_tx_details(params[:log_id])
  end
  
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_management_index_path, :notice=>"User has been deleted") }
      format.xml  { head :ok }
    end
  end
  
  def check_role
    roles=Role.where(:id=>params[:role_ids].split(','))
    business_roles=roles.select {|role| role.require_business?}
    render :text=>business_roles.any?
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
    @user=User.find(params[:id])
    qr_code=@user.qr_code
    @new_qrcode=qr_code.scan
    render :text=>(render_to_string :partial=> "user_code_container")
  end
  
  def reissue_code_from_listing_txs
    @user=User.find(params[:id])
    old_qr_code=@user.qr_code
    @qr_code=old_qr_code.scan
    render :text=>(render_to_string :partial=> "qrcode_container")
  end
  
  def list_businesses_by_program_type    
    @results=Account.listing_user_enrollments(params[:uid],params[:program_type_id])
    render :text=>(render_to_string :partial=> "listing_enrollments_container")
  end
  
  def list_transactions
    @user=User.find(params[:id]) 
    @business=Business.find(params[:business_id])   
    pt=Program.find(params[:program_id]).program_type
    if pt.name==ProgramType::AS[:marketing]
      @transactions=Log.joins(:transaction=>:transaction_type)
                       .where("logs.business_id=#{params[:business_id]} and logs.campaign_id IS NOT NULL and logs.user_id=#{params[:id]}")
                       .select("transactions.*,transaction_types.name,transaction_types.fee_amount,transaction_types.fee_percentage,user_id,logs.created_at,place_id,engagement_id")
                       .order("transactions.created_at desc")                       
    else
      @transactions=Log.joins(:transaction=>:transaction_type)
                       .where("logs.business_id=#{params[:business_id]} and logs.campaign_id=NULL and logs.user_id=#{params[:id]}")
                       .select("transactions.*,transaction_types.name,transaction_types.fee_amount,transaction_types.fee_percentage,user_id,logs.created_at,place_id,engagement_id")
                       .order("transactions.created_at desc")
    end
  end
  
  def manage_user_accounts
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @user=User.find(params[:id])
    @accounts=Account.joins([:account_holder,"LEFT OUTER JOIN campaigns on campaigns.id=accounts.campaign_id LEFT OUTER JOIN programs on programs.id=campaigns.program_id LEFT OUTER JOIN program_types ON program_types.id=programs.program_type_id LEFT OUTER JOIN businesses ON programs.business_id=businesses.id"])
                     .where("account_holders.model_id=#{params[:id]} and account_holders.model_type='User'")
                     .select("accounts.id, accounts.amount as amount, accounts.cumulative_amount as cumulative_amount, campaigns.name as c_name, program_types.name as pt_name, businesses.name as b_name, accounts.created_at, accounts.business_id")
                     .paginate(:page => @page,:per_page => Account::per_page )
  end
  
  def withdraw_account
    account=Account.find(params[:account_id])
    account=account.withdraw_from_account(params[:amount].to_f,current_user.id)
    if account
      at_text=account.associated_to_business? ? account.business.name : account.campaign.try(:name) 
      flash[:notice]="An amount of #{params[:amount]} points has been withdrawn from account at #{at_text}"
      redirect_to :action=>:manage_user_accounts, :page=>params[:page]
    else
      flash[:error]="#{account.errors.full_messages.join(' , ')}"
      redirect_to :action=>:manage_user_accounts, :page=>params[:page]
    end
  end
  
  def deposit_account
    account=Account.find(params[:account_id])
    account=account.deposit_to_account(params[:amount].to_f,current_user.id)
    if account
      at_text=account.associated_to_business? ? account.business.name : account.campaign.try(:name) 
      flash[:notice]="An amount of #{params[:amount]} points has been deposited to user account at #{at_text}"
      redirect_to :action=>:manage_user_accounts, :page=>params[:page]
    else
      flash[:error]="#{account.errors.full_messages.join(' , ')}"
      redirect_to :action=>:manage_user_accounts, :page=>params[:page]
    end
  end
  
  def redeem_rewards
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @user=User.find(params[:id])
    @rewards= Reward.joins(:campaign=>[:program=>[:program_type,:business],:accounts=>[:account_holder]])
                    .where("program_types.id=#{ProgramType.find_by_name(ProgramType::AS[:marketing]).id} and rewards.is_active=true and account_holders.model_id=#{params[:id]} and account_holders.model_type='User'")
                    .select("(SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id and users_enjoyed_rewards.user_id=#{params[:id]}) As redeemCount,rewards.id,rewards.name as r_name,campaigns.name as c_name, program_types.name as pt_name, businesses.name as b_name, campaigns.created_at, (SELECT count(*) from users_enjoyed_rewards where users_enjoyed_rewards.reward_id=rewards.id) As numberOfRedeems,rewards.max_claim, rewards.max_claim_per_user")
                    .group("rewards.id")
                    .paginate(:page => @page,:per_page => Reward::per_page )
                     
  end
  
  def redeem_reward_for_user
    begin
      @user=User.find(params[:id])
      reward=Reward.find(params[:reward_id])
      user_account=reward.campaign.user_account(@user)
      if (reward.max_claim_per_user.nil? || reward.max_claim_per_user=="0"|| params[:redeemCount].to_i < reward.max_claim_per_user.to_i) and (reward.max_claim.nil? || reward.max_claim=="0" || params[:numberOfRedeems].to_i < reward.max_claim.to_i)          
        reward.is_claimed_by(@user,user_account,nil,nil,nil)
        flash[:notice]="#{reward.name} Reward is claimed by #{@user.full_name}"
        redirect_to :action=>:redeem_rewards, :page=>params[:page]
      else
        per_user=params[:redeemCount].to_i >= reward.max_claim_per_user.to_i ? "per user" : "for all users"
        flash[:error]="Maximum number of claiming #{reward.name} reward #{per_user} is reached"
        redirect_to :action=>:redeem_rewards, :page=>params[:page]      
      end
    rescue Exception => e
      logger.error "Exception #{e.class}: #{e.message}"
		 	respond_to do |format|
			  format.xml { render :text => e.message,:status=>500 }
		  end
		 end
  end
  
  def list_engagements
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @user=User.find(params[:id])
    @engagements= Engagement.joins(:campaign=>[:program=>[:program_type,:business],:accounts=>[:account_holder]])
                            .where("program_types.id=#{ProgramType.find_by_name(ProgramType::AS[:marketing]).id} and account_holders.model_id=#{params[:id]} and account_holders.model_type='User'")
                            .select("campaigns.ctype,accounts.amount as account_amount,engagements.id,engagements.amount,engagements.name as eng_name,campaigns.name as c_name, program_types.name as pt_name, businesses.name as b_name, campaigns.created_at")
                            .group("engagements.id")
                            .paginate(:page => @page,:per_page => Reward::per_page )
  end
  
  def make_engagement
    begin
      @user=User.find(params[:id])
      engagement=Engagement.where(:id=>params[:engagement_id]).first
      if engagement.present? and !engagement.is_started
        flash[:error]="Engagement no longer running!"
      elsif engagement.campaign.spend_campaign?
        if params[:amount].present?
          @user.made_spend_engagement_at(nil,engagement.campaign.try(:program).try(:business),engagement.campaign,params[:amount].to_f,nil,nil)
          flash[:notice]="#{@user.full_name} has made an engagement with #{engagement.campaign.name} and earned #{params[:amount]} #{MeasurementType.find(engagement.campaign.measurement_type_id).name}"
        else
          flash[:error]="You must enter the ring up amount first"
        end    
      else
        @user.snapped_qrcode(nil,engagement,nil,nil,nil, current_user.id)
        flash[:notice]="#{@user.full_name} has made an engagement with #{engagement.campaign.name} and earned #{engagement.amount} #{MeasurementType.find(engagement.campaign.measurement_type_id).name}"
      end	
      redirect_to :action=>:list_engagements, :page=>params[:page]										 
    rescue Exception=>e
      logger.error "Exception #{e.class}: #{e.message}"
      flash[:error]=e.message
      redirect_to :action=>:list_engagements, :page=>params[:page]										 
    end
  end
  
  def logged_actions
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @user=User.find(params[:id])
    @action_id=params[:action_id].to_i.zero? ? Action.find_by_name(Action::CURRENT_ACTIONS[:engagement]).id : params[:action_id].to_i
    @action=Action.find(@action_id)
    join_type=@action.name==Action::CURRENT_ACTIONS[:engagement] ? "engagements" : "rewards"
    @logged_actions=Log.select("logs.*,transactions.*,transaction_types.name as tt_name,transaction_types.fee_amount,transaction_types.fee_percentage,rewards.name as reward_name, rewards.needed_amount as spent_amount,actions.name as action_name,engagements.name as ename,businesses.name as bname,engagements.amount,places.name as pname,users.first_name,users.last_name,program_types.name as program_name,campaigns.name as cname,measurement_types.name as amount_type")
                       .joins([:user,[:transaction=>:transaction_type],"LEFT OUTER JOIN actions ON actions.id=logs.action_id LEFT OUTER JOIN places ON logs.place_id=places.id LEFT OUTER JOIN engagements ON engagements.id=logs.engagement_id LEFT OUTER JOIN rewards ON rewards.id=logs.reward_id LEFT OUTER JOIN campaigns ON campaigns.id=rewards.campaign_id LEFT OUTER JOIN measurement_types ON campaigns.measurement_type_id=measurement_types.id LEFT OUTER JOIN programs ON campaigns.program_id=programs.id LEFT OUTER JOIN businesses ON businesses.id=programs.business_id LEFT OUTER JOIN program_types ON program_types.id=programs.program_type_id"])                    
                       .where("logs.user_id=#{params[:id]} and actions.id=#{@action_id}")
                       .order("logs.created_at DESC")
                       .paginate(:page => @page,:per_page => Log::per_page )
    if request.xhr?
      render :text=>(render_to_string :partial=> "logs",:layout=>false)
    end                         
  end
  
  def manage_user_enrollments
    ids=Program.joins([:program_type, :campaigns=>[:accounts=>:account_holder]])
               .where("account_holders.model_id=#{params[:user_id]} and account_holders.model_type='User' and program_types.id=#{params[:pt_id]}")
               .select("accounts.id")
    if request.xhr?
      if Account.where(:id=>ids).update_all(:status=>params[:enroll].to_i)
        render :text=>params[:enroll].to_i
      else
        render :text=>!params[:enroll].to_i
      end
    end
  end
  
  def list_campaigns
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @user=User.find(params[:id])
    @business= Business.find(params[:business_id])
    @campaigns=Campaign.joins("LEFT OUTER JOIN accounts ON accounts.campaign_id=campaigns.id LEFT OUTER JOIN account_holders ON account_holders.id=accounts.account_holder_id",:program=>[:program_type,:business])
                       .where("businesses.id=#{params[:business_id]} and programs.id=#{params[:program_id]} and account_holders.model_id=#{params[:id]} and account_holders.model_type='User'")
                       .select("campaigns.id as c_id,campaigns.name as c_name,program_types.name as p_name, businesses.name as b_name, campaigns.created_at,accounts.status AS enrollment_status")
                       .paginate(:page => @page,:per_page => Log::per_page )
  end
  
  def manage_campaign_enrollments
    ids=Campaign.joins(:accounts=>:account_holder)
                .where("account_holders.model_id=#{params[:user_id]} and account_holders.model_type='User' and campaigns.id=#{params[:c_id]}")
                .select("accounts.id")
    if request.xhr?
      if Account.where(:id=>ids).update_all(:status=>params[:enroll].to_i)
        render :text=>params[:enroll].to_i
      else
        render :text=>!params[:enroll].to_i
      end
    end
  end
  
  def view_all_qrcodes_transactions
    @all_logs=Log.joins(:qr_code,:business,:place).order("created_at DESC").where(:user_id=>params[:user_id])
    render :template=>"transactions"
  end
  
  def aggregate_transactions_report
    @user = User.find(params[:id])
    @page = params[:page].to_i.zero? ? 1 : params[:page].to_i
    @filters= params[:filters].to_i.zero? ? 3 : params[:filters].to_i
    @business_id = params[:business_id].to_i.zero? ? nil : params[:business_id].to_i
    @from_date=params[:from_date].to_i.zero? ? nil : params[:from_date]
		@to_date=params[:to_date].to_i.zero? ? nil : params[:to_date]
    @all_transactions= @user.all_transactions(:from_date=>@from_date, :to_date=>@to_date, :business_id=>@business_id, :filters=> @filters.to_i)
                            .paginate(:page => @page,:per_page =>@@per_page )
  end
  
  def check_txs_updates
    @qr_code= QrCode.find(params[:qr_code_id])
    @latest_transactions= Log.latest_qrcode_transactions(@qr_code.id)
    @user= User.find(params[:id])
    result={}
    if @latest_transactions.any? and @latest_transactions.first.log_id > params[:last_log_id].to_i
      @qr_code=@user.qr_code
      result[:qr_code_updates]= render_to_string :partial=> "qrcode_container"
      result[:txs_rows]= render_to_string :partial=> "transaction_row"
      result[:new_qrcode]= @qr_code.id
      result[:size]= @latest_transactions.length
      result[:last_log_id]= @latest_transactions.first.log_id
    end
    if request.xhr?
      render :json=>result.to_json
    end
  end
  
  def list_places_and_bizs
    @businesses=Business.all
    @places=Place.all
  end
    
  def enroll_in_money_program
    user = User.find params[:users_management_id]
    business = Business.find params[:business_id]
    user.enroll(business.money_program)
    flash[:notice] = "Enrolled in Money Program @ #{business.name}"
    redirect_to users_management_path(user)
  end
end
