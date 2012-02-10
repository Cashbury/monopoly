class MoneyProgramsController < ApplicationController
	before_filter :authenticate_user!, :require_admin
	before_filter :load_business	
	before_filter :load_user, :only => [:unenroll, :cashout, :deposit, :withdraw, :refresh_user]
	layout false

	def lookup_user
		@user = User.find_by_email params[:email]		
	end

	def refresh_user
		render 'lookup_user.html'
	end

	def unenroll
		ca = @user.cash_account_for(@business)
		ca.cashout(current_user)
		@user.programs.delete @business.money_program
	end

	def cashout
		ca = @user.cash_account_for(@business)
		ca.cashout(current_user)
	end

	def deposit
		to_account = case params[:account_type]
		when 'cash'
			@user.cash_account_for(@business)
		when 'cashbury'
			@user.cashbury_account_for(@business)
		else
			raise "Invalid account_type"
		end
		amount = params[:amount].to_f
		to_account.deposit(amount, current_user)
		@message = "Successfully deposited #{amount} #{params[:account_type]}."
		render 'deposit_or_withdraw.html'
	end

	def withdraw
		from_account = case params[:account_type]
		when 'cash'
			@user.cash_account_for(@business)
		when 'cashbury'
			@user.cashbury_account_for(@business)
		else
			raise "Invalid account_type"
		end
		amount = params[:amount].to_f
		from_account.withdraw(amount, current_user)
		@message = "Successfully withdrew #{amount} #{params[:account_type]}."		
		render 'deposit_or_withdraw.html'
	end

	protected
	def load_business
		@business = Business.find params[:business_id]
	end

	def load_user
		@user = User.find params[:user_id]
	end
end
