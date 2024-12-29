class UploadsController < ApplicationController
  before_action :authenticate_user!

  def process_upload
    file = params[:file]
    resource_type = params[:resource_type] # 'posts', 'tags', 'combined'

    # Verificar se o arquivo foi enviado e se o tipo de recurso é válido
    if file && file.content_type == "text/plain" && %w[posts tags combined].include?(resource_type)
      file_path = Rails.root.join("tmp", file.original_filename)
      
      # Salvar o arquivo temporariamente
      File.open(file_path, "wb") { |f| f.write(file.read) }

      # Enfileirar o processamento com Sidekiq
      UploadProcessorJob.perform_later(file_path.to_s, resource_type, current_user.id)

      render json: { message: "#{resource_type.capitalize} upload iniciado." }, status: :accepted
    else
      render json: { error: "Arquivo inválido ou tipo de recurso não suportado." }, status: :unprocessable_entity
    end
  end
end
