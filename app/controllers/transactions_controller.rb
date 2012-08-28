class TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @transactions = Transaction.order('created_at DESC')
  end

  def refund
    transaction = Transaction.find params[:id]
    transaction.refund!(current_user)
    flash[:notice] = "Transaction refunded"
    redirect_to :back
  end
end
