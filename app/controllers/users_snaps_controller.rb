class UsersSnapsController < ApplicationController
	before_filter :set_sorting_direction,:only=>[:index]
  def index
		@business_id = params[:business_id].nil? ? 0 : params[:business_id].to_i
		@place_id = params[:place_id].nil? ? 0 : params[:place_id].to_i
		@time = params[:used_at].nil? ? 0 : params[:used_at].to_i
		@sorting_by = params[:sorting_id].nil? ? ' ' : params[:sorting_id]
		@page = params[:page].to_i.zero? ? 1 : params[:page].to_i
		@results, @number_of_pages = UsersSnaps.search :business_id => @business_id.zero? ? nil : @business_id,
                                                   :place_id    => @place_id.zero? ? nil : @place_id,
                                                   :time        => @time.zero? ? nil : @time,
																									 :sort_by => @sorting_by.blank? ? "user_id" : @sorting_by,
                                                   :sort_direction=> @sorting_direction,
                                                   :page => @page
		#@base_url = "/users_snaps/businesses/" + @business_id.to_s + "/places/" + @place_id.to_s + "/time/" + @time.to_s + "/sorting/" + @sorting_by + "/index/"
		@base_url = "/users_snaps/businesses/" + @business_id.to_s + "/places/" + @place_id.to_s + "/index/"
  end

  def snap
		@snap=UsersSnaps.new(:user_id=>params[:user_id],
  											 :qr_code_id=>params[:qr_code_id],
  											 :used_at=>params[:used_at])
		respond_to do |format|
			if @snap.save
      	format.xml {render :xml => @snap, :status => :created}
     	else
     		format.xml {render :text => @snap.errors.full_message, :status => 500}
     	end
    end											 
  end
  
  private
		def set_sorting_direction
			params[:sorting_direction] = nil unless ['ASC','DESC'].include?(params[:sorting_direction])
      unless params[:sorting_direction].blank?
				session[:sorting_direction] = (params[:sorting_direction] == 'ASC')? 'ASC' : 'DESC'
      end
      if session[:sorting_direction].blank?
         session[:sorting_direction] = 'ASC'
      end
      @sorting_direction = session[:sorting_direction]
    end
end
