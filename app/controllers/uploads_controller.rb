class UploadsController < ApplicationController
  def process_upload
    if params[:file].present?
      file_path = params[:file].path
      ImportPostsJob.perform_later(file_path)
      render json: { message: 'Arquivo enviado com sucesso. O processamento será feito em segundo plano.' }, status: :ok
    else
      render json: { error: 'Nenhum arquivo foi enviado.' }, status: :unprocessable_entity
    end
  end
end