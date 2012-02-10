module MoneyProgramsHelper
	def cash_balance_at(user, business)
		user.cash_account_for(business).amount
	end

	def cashbury_balance_at(user, business)
		user.cashbury_account_for(business).amount
	end
	def total_balance_at(user, business)
		cash_balance_at(user, business) + cashbury_balance_at(user, business)
	end

	def refresh_user_javascript_tag(user, business)
		js = <<-JS
			$('#money_program_lookup').load("#{refresh_user_money_program_path(:user_id => @user, :business_id => @business)}")
		JS
		raw javascript_tag(js)
	end
end
