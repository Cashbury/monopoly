class UsersSnapsController < ApplicationController
	
  def index
		@business_id = params[:business_id].to_i.zero? ? nil : params[:business_id].to_i
		@place_id = params[:place_id].to_i.zero? ? nil : params[:place_id].to_i
		@start_date=params[:start_date].to_i.zero? ? nil : params[:start_date]
		@end_date=params[:end_date].to_i.zero? ? nil : params[:end_date]
		@page = params[:page].to_i.zero? ? 1 : params[:page].to_i
		@results=UsersSnap.search :business_id => @business_id,
														  :place_id    => @place_id,
                              :start_date  => @start_date,
                              :end_date    => @end_date,
														  :page        => @page
  end

  def snap
		@snap=UserSnap.new(:user_id   =>params[:user_id],
  										 :qr_code_id=>params[:qr_code_id],
  										 :used_at   =>params[:used_at])
		respond_to do |format|
			if @snap.save
      	format.xml {render :xml => @snap, :status => :created}
     	else
     		format.xml {render :text => @snap.errors.full_message, :status => 500}
     	end
    end											 
  end
  
end
