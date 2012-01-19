class Users::BusinessesController < ApplicationController
  layout "businessend"
  before_filter :authenticate_user!
  before_filter :get_places
  before_filter :prepare_hours , :only=>:open_sign


  def index
  end

  def show
  end

  def primary_place
    #if current_user.sign_in_count <= 1
      if request.post?
        params[:is_primary]=true if current_user.sign_in_count <=1
        @place = Place.save_place_by_geolocation(params,current_user)
        if @place.save
          redirect_to :action=>:open_sign, :id=>@place.id
        end
      end
    #else
      #redirect to root
    #end
  end


  def open_sign
    @place = Place.where(:user_id=> current_user.id, :id=>params[:id]).limit(1).first
    if @place && request.post?
      @place.add_open_hours(params[:open_hour])
      if @place.save
        redirect_to :action=>:set_rewards
      else
        redirect_to :action=>:open_hour , :id=>@place.id
      end
    end
  end

  def set_rewards

  end

  def get_places
    @places ||= Place.where(:user_id=>current_user.id)
  end

  def savings
    begin      
      account_ids = current_user.cashbury_accounts.select(:id).collect(&:id)      
      business = Business.find(params[:id]) if params[:id]

      if business && !business.has_money_program?
        respond_to do |format|
          format.xml { render :xml => { :error => "Business doesn't have money program" }, :status => 422 }
        end
        return
      end

      cashbury_savings = if business        
        Transaction.where(:from_account => account_ids, :to_account => business.cashbury_account.id).sum(:before_fees_amount)
      else
        Transaction.where(:from_account => account_ids).sum(:before_fees_amount)
      end

      result = { :total_savings => cashbury_savings }

      respond_to do |format|
        format.xml { render :xml => result }
      end
    rescue Exception=>e
      logger.error "A problem occurred: #{e.message}"
      render :text => e.message, :status => 500
    end
  end

end
