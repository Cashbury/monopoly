class Users::UsersSnapsController < Users::BaseController
	def snap
		begin		
		  qr_code=QrCode.where(:hash_code=>params[:qr_code_hash],:related_type=>"Engagement").first	   
      account,campaign,program,engagement_amount=current_user.snapped_qrcode(qr_code,params[:place_id],params[:lat],params[:long])    
			respond_to do |format|
			 if qr_code.status==false
          format.xml { render :text => "QR code not Active!",:status=>500 }
        else
          format.xml {render :xml => snap_hash(account,campaign,program,engagement_amount), :status => 200}
        end 
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
		s[:snap].merge!({:campaign_id          => campaign.id})
		s[:snap].merge!({:program_id           => program.id})
		s[:snap].merge!({:engagements_points   => engagement_amount})
		s[:snap].merge!({:account_points       => account.amount})
    s
  end
end
