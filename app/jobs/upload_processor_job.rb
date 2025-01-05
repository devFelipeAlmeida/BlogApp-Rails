class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(blob_id, user_id)
    # Encontrar o blob pelo ID
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    
    # Log para verificar a chave do arquivo
    Rails.logger.info "Blob ID: #{blob.id}, Key: #{blob.key}"  # Verifique se a key é a mesma

    # Levantar erro caso o blob não seja encontrado
    raise "Blob não encontrado com ID #{blob_id}" if blob.nil?

    # Baixar o conteúdo do arquivo de maneira segura
    file_data = blob.download

    # Salvar o conteúdo em um arquivo temporário para usar o File.readlines
    tempfile = Tempfile.new(['uploaded_file', '.txt'])
    tempfile.binmode
    tempfile.write(file_data)
    tempfile.rewind

    # Processar o arquivo
    process_file(tempfile.path, user_id)

    # Fechar e excluir o arquivo temporário após o processamento
    tempfile.close
    tempfile.unlink
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
