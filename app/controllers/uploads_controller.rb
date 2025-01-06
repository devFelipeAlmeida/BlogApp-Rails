class UploadsController < ApplicationController
  def process_upload
    file = params[:file]
  
    if file && file.content_type == "text/plain"
      unique_filename = "#{Time.now.to_i}_#{file.original_filename}"
      blob = ActiveStorage::Blob.create_and_upload!(
        io: file.tempfile, 
        filename: unique_filename, 
        content_type: file.content_type
      )
  
      UploadProcessorJob.perform_later(blob.id, current_user.id)
  
      redirect_to root_path, notice: t("flash.posts.upload_sidekiq")
    else
      redirect_to root_path, alert: t("flash.posts.not_upload_sidekiq")
    end
  end
  
end
