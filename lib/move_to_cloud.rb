class MoveToCloud < Struct.new(:upload_id)
  def perform
    tmp_upload = TmpImage.where(:id=>self.upload_id).first
    if tmp_upload
      tmp_upload.move_to_cloud
    end
  end
end