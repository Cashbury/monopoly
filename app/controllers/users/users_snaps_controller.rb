class Users::UsersSnapsController < Users::BaseController
	def snap
		begin
			@result=Program.joins(:engagements=>:qr_codes).where(:qr_codes => { :id => params[:qr_code_id] }).select("programs.id,engagements.points").first
			@account=Account.where(:user_id=>current_user.id,:program_id=>@result.id).first
			
			Account.transaction do
				@account.increment!(:points,@result.points.to_i)
				@snap=UsersSnap.create!(:user_id   =>current_user.id,
		  										  	  :qr_code_id=>params[:qr_code_id],
		  										      :used_at   =>Date.today)
			end  										     
			respond_to do |format|
			  format.xml {render :xml => @account, :status => 200}
	    end											 
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
			render :text => e.message, :status => 500
		end
  end
end
