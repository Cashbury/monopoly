module AccountsHelper
  def account_type(account)
    if account.is_cashbury?
      "Cashbury"
    elsif account.is_money?
      "Cash"
    elsif account.is_reserve?
      "Cash - Reserve"
    else
      "Marketing"
    end
  end
end
