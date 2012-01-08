class TransactionsController < ApplicationController
  before_filter :authenticate_user!, :require_admin

  def index
    @transactions = Transaction.order('created_at DESC')
  end

  def void
    transaction = Transaction.find params[:id]
    transaction.void!(current_user)
    flash[:notice] = "Transaction voided"
    redirect_to :back
  end
end
