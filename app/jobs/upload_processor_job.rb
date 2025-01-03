class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(file_path, user_id)
    user = User.find(user_id)
    Rails.logger.info "Tentando abrir o arquivo: #{file_path}"

    # Verifique se o arquivo realmente existe antes de tentar processá-lo
    if File.exist?(file_path)
      Rails.logger.info "Arquivo encontrado, processando..."
      
      # Processar o arquivo linha por linha
      File.readlines(file_path).each do |line|
        # Espera-se o formato: título | conteúdo | tags separadas por vírgula
        title, content, tags = line.strip.split("|")
        next unless title.present? && content.present?

        tags = tags.present? ? tags.split(",").map(&:strip) : []

        ActiveRecord::Base.transaction do
          # Cria o post associado ao usuário
          post = Post.create!(title: title.strip, content: content.strip, user: user)

          # Cria as tags e associa ao post
          tags.each do |tag_name|
            tag = Tag.find_or_create_by!(name: tag_name)
            post.tags << tag
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error "Erro ao processar linha: #{line.strip}. Detalhes: #{e.message}"
      end
    else
      Rails.logger.error "Erro: Arquivo não encontrado no caminho #{file_path}"
    end
  end
end
