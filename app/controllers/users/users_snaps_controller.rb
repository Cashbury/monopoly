class Users::UsersSnapsController < Users::BaseController
	def snap
		begin			     
			respond_to do |format|
			  format.xml {render :xml => snap_hash(current_user.snapped_qrcode(params[:qr_code_hash],
			                                                                   params[:place_id],
			                                                                   params[:lat],params[:long])), :status => 200}
	    end											 
		rescue Exception=>e
			logger.error "Exception #{e.class}: #{e.message}"
			render :text => e.message, :status => 500
		end
  end
  
  private
  def snap_hash(account,campaign,program,engagement_amount)
    s = {:snap => {}}
		s[:snap].merge!({:business_id          => program.business.id})
		s[:snap].merge!({:business_name        => program.business.name})
		s[:snap].merge!({:campaign_id          => campaign})
		s[:snap].merge!({:program_id           => program.id})
		s[:snap].merge!({:engagements_points   => engagement_amount})
		s[:snap].merge!({:account_points       => account.amount})
    s
  end
end
