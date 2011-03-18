class LoyalCustomersController < ApplicationController
	before_filter :authenticate_user!,:require_admin
	def index
		@business_id = params[:business_id].to_i.zero? ? nil : params[:business_id].to_i
		@place_id = params[:place_id].to_i.zero? ? nil : params[:place_id].to_i
		@from_date=params[:from_date].to_i.zero? ? nil : params[:from_date]
		@to_date=params[:to_date].to_i.zero? ? nil : params[:to_date]
		@page = params[:page].to_i.zero? ? 1 : params[:page].to_i
		@results=UserAction.search :business_id => @business_id,
														   :place_id    => @place_id,
                               :from_date   => @from_date,
                               :to_date     => @to_date,
														   :page        => @page,
														   :type        => UserAction::LIST_TOP_LOYAL_CUSTOMERS												   
	end
end
