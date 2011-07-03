class Users::UsersSnapsController < Users::BaseController
	def snap
		begin		
		  qr_code=QrCode.where(:hash_code=>params[:qr_code_hash],:associatable_type=>"Engagement").first
		  engagement=qr_code.try(:engagement)       
		  if qr_code.nil?
		    respond_with_error("QR Code no longer exists in the system!")
      elsif !qr_code.status
        respond_with_error("QR Code not Active!")
      elsif !engagement.is_started
        respond_with_error("Engagement no longer running!")          
      else
        respond_to do |format|
          account,campaign,program,after_fees_amount=current_user.snapped_qrcode(qr_code,engagement,params[:place_id],params[:lat],params[:long])
          format.xml {render :xml => snap_hash(account,engagement,campaign,program,after_fees_amount), :status => 200}
        end
      end											 
    #rescue Exception=>e
    #  logger.error "Exception #{e.class}: #{e.message}"
    #  render :text => e.message, :status => 500
    end
  end
  
  private
  def snap_hash(account,engagement,campaign,program,after_fees_amount)
    item=engagement.item
    item_photo=item.try(:item_image).try(:photo)
    brand_photo= program.try(:business).try(:brand).try(:brand_image).try(:photo)
    s = {:snap => {}}
		s[:snap].merge!({:business_id          => program.try(:business).try(:id)})
		s[:snap].merge!({:brand_name           => program.try(:business).try(:brand).try(:name)})
		s[:snap].merge!({:brand_image          => program.try(:business).try(:brand).try(:brand_image).nil? ? nil : URI.escape(program.business.brand.brand_image.photo.url(:normal))})
		s[:snap].merge!({:brand_image_fb       => program.try(:business).try(:brand).try(:brand_image).nil? ? nil : URI.escape(program.business.brand.brand_image.photo.url(:thumb))})
		s[:snap].merge!({:campaign_id          => campaign.id})
		s[:snap].merge!({:program_id           => program.id})
		s[:snap].merge!({:item_name            => item.try(:name)})
		s[:snap].merge!({:item_image           => item_photo.nil? ? "http://#{request.host_with_port}/images/icon.png" : URI.escape(item_photo.url(:thumb)) })
		s[:snap].merge!({:engagement_amount    => after_fees_amount})
		s[:snap].merge!({:account_amount       => account.amount})
		s[:snap].merge!({:fb_engagement_msg    => engagement.fb_engagement_msg})
    s
  end
  
  def respond_with_error(msg)
    respond_to do |format|
      format.xml { render :text => msg ,:status=>500 }
    end
  end
end
