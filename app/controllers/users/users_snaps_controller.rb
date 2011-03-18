class Users::UsersSnapsController < Users::BaseController
	def snap
		begin
			current_user=User.find(params[:uid]) unless params[:uid].blank?
 			result =Program.joins(:engagements=>:qr_codes).where(:qr_codes => { :hash_code => params[:qr_code_hash] }).select("programs.id,programs.initial_points,engagements.points").first
			account=Account.where(:user_id=>current_user.id,:program_id=>result.id).first
			date=Date.today.to_s
			Account.transaction do
				qr_code=QrCode.find_by_hash_code(params[:qr_code_hash])
				qr_code.scan
				
				if account.nil?
					account=Account.create!(:user_id=>current_user.id,:program_id=>result.id,:points=>result.initial_points)
				end
				account.increment!(:points,result.points.to_i)
				snap=UserAction.create!(:user_id    =>current_user.id,
		  										  	  :qr_code_id =>qr_code.id,
		  										  	  :business_id=>account.program.business.id,
		  										  	  :used_at    =>date)
			end							     
			respond_to do |format|
			  format.xml {render :xml => snap_hash(account,account.program,result.points), :status => 200}
	    end											 
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
			render :text => e.message, :status => 500
		end
  end
  
  private
  def snap_hash(account,program,engagement_points)
    s = {:snap => {}}
		s[:snap].merge!({:business_id          => program.business.id})
		s[:snap].merge!({:program_id           => program.id})
		s[:snap].merge!({:engagements_points   => engagement_points})
		s[:snap].merge!({:account_points       => account.points})
    s
  end
end
