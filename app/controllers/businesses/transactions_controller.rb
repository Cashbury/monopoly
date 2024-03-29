class Businesses::TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @business = Business.find params[:business_id]
    @transactions = @business.transactions.order('created_at DESC')
  end
end
