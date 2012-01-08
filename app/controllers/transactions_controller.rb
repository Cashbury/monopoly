class TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @transactions = Transaction.order('created_at DESC')
  end
end
