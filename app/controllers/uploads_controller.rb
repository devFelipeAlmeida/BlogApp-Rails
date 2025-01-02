class UploadsController < ApplicationController
  before_action :authenticate_user!

  def process_upload
    file = params[:file]
    resource_type = params[:resource_type] # 'posts', 'tags', 'combined'

    if file.present? && file.content_type == "text/plain" && %w[posts tags combined].include?(resource_type)
      file_path = Rails.root.join("tmp", file.original_filename)

      # Salvar o arquivo temporariamente
      File.open(file_path, "wb") { |f| f.write(file.read) }

      # Enfileirar o processamento com Sidekiq
      UploadProcessorJob.perform_later(file_path.to_s, resource_type, current_user.id)

      # Redirecionar com mensagem de sucesso
      redirect_to root_path, notice: t("flash.posts.upload_sidekiq")
    else
      # Redirecionar com mensagem de erro
      redirect_to root_path, alert: t("flash.posts.not_upload_sidekiq")
    end
  end
end
