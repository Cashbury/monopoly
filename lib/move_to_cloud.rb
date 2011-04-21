class MoveToCloud < Struct.new(:upload_id)
  def perform
    tmp_upload = TmpUpload.find :first, :conditions=>{:id=>self.upload_id}
    if tmp_upload
      tmp_upload.move_to_cloud
    else
    end
  end
end