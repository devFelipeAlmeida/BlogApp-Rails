class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(blob_id, user_id)
    Rails.logger.info "Iniciando processamento do job para blob ID: #{blob_id}, usuário ID: #{user_id}"
  
    # Verificar se o blob é encontrado
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    if blob.nil?
      Rails.logger.error "Blob não encontrado com ID: #{blob_id}"
      return
    end
  
    Rails.logger.info "Blob encontrado: #{blob.inspect}"
  
    # Tente baixar o arquivo
    begin
      file_data = blob.download
      Rails.logger.info "Arquivo baixado com sucesso: #{file_data[0..100]}..." # Mostra os primeiros 100 caracteres
    rescue => e
      Rails.logger.error "Erro ao baixar o arquivo do blob: #{e.message}"
      return
    end
  
    # Salvar o conteúdo do arquivo em um arquivo temporário
    tempfile = Tempfile.new(['uploaded_file', '.txt'])
    tempfile.binmode
    tempfile.write(file_data)
    tempfile.rewind
  
    # Processar o arquivo
    begin
      process_file(tempfile.path, user_id)
    rescue => e
      Rails.logger.error "Erro durante o processamento do arquivo: #{e.message}"
    ensure
      tempfile.close
      tempfile.unlink
    end
  end

  private

  def process_file(file_path, user_id)
    user = User.find(user_id)
  
    # Ler o arquivo linha por linha
    File.readlines(file_path).each do |line|
      title, content, tags = line.strip.split("|")
      next unless title.present? && content.present?
  
      # Separar as tags, se houver, e garantir que não há espaços desnecessários
      tags = tags.present? ? tags.split(",").map(&:strip) : []
  
      # Processar cada post dentro de uma transação
      ActiveRecord::Base.transaction do
        post = Post.create!(title: title.strip, content: content.strip, user: user)
  
        # Criar as tags associando diretamente o post_id
        tags.each do |tag_name|
          Tag.create!(name: tag_name, post_id: post.id)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erro ao processar linha: #{line.strip}. Detalhes: #{e.message}"
    end
  end
end
