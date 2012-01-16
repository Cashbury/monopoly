class Users::TransactionsController < ApplicationController
  before_filter :authenticate_user!

  def index
    if current_user.role? Role::AS[:admin]
      @user = User.find params[:user_id]
    else
      @user = current_user
    end
    account_ids = @user.accounts.select('accounts.id').collect(&:id)
    account_ids << -1
    @transactions = Transaction.where('from_account IN (?) OR to_account IN (?)', account_ids, account_ids).order('created_at DESC')
  end
end
