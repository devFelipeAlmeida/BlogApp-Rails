class UploadsController < ApplicationController
  def process_upload
    file = params[:file]

    if file && file.content_type == "text/plain"
      file_path = Rails.root.join("tmp", file.original_filename)

      File.open(file_path, "wb") { |f| f.write(file.read) }

      UploadProcessorJob.perform_later(file_path.to_s, current_user.id)

      redirect_to root_path, notice: t("flash.posts.upload_sidekiq")
    else
      redirect_to root_path, alert: t("flash.posts.not_upload_sidekiq")
    end
  end
end
