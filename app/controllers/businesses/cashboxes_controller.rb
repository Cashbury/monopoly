class Businesses::CashboxesController < ApplicationController
  before_filter :find_business

  def edit
    @account = @business.cashbox
    @account_option = @account.account_option || @account.create_account_option
  end

  def update
    @account = @business.cashbox
    @account_option = @account.account_option

    if @account_option.update_attributes params[:account_option]
      flash[:notice] = "Cashbox settings updated."
      redirect_to [@business, @business.money_program]
    else
      render :edit
    end
  end

  protected
  def find_business
    @business = Business.find params[:business_id]
  end
end
