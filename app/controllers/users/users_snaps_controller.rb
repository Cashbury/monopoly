class Users::UsersSnapsController < Users::BaseController
	def snap
		begin
			result =Program.joins(:engagements=>:qr_codes).where(:qr_codes => { :id => params[:qr_code_id] }).select("programs.id,programs.initial_points,engagements.points").first
			account=Account.where(:user_id=>current_user.id,:program_id=>result.id).first
			date=Date.today.to_s
			Account.transaction do
				qr_code=QrCode.find_by_id(params[:qr_code_id])
				qr_code.scan
				
				if account.nil?
					account=Account.create!(:user_id=>current_user.id,:program_id=>result.id,:points=>result.initial_points)
				end
				account.increment!(:points,result.points.to_i)
				snap=UserAction.create!(:user_id    =>current_user.id,
		  										  	  :qr_code_id =>params[:qr_code_id],
		  										  	  :business_id=>account.program.business.id,
		  										  	  :used_at    =>date)
			end  										     
			respond_to do |format|
			  format.xml {render :xml => account, :status => 200}
	    end											 
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
			render :text => e.message, :status => 500
		end
  end
end
