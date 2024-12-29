# app/jobs/upload_processor_job.rb
class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(file_path, resource_type, user_id)
    user = User.find(user_id)

    # Processar o arquivo de maneira otimizada
    File.readlines(file_path).each do |line|
      # Divide a linha em título, conteúdo e tags
      title, content, tags = line.split("|")
      next unless title.present? && content.present? && tags.present?  # Ignora linhas mal formatadas

      tags = tags.split(",").map(&:strip)

      # Inicia uma transação para garantir que a criação seja atômica
      ActiveRecord::Base.transaction do
        if resource_type == "posts" || resource_type == "combined"
          # Cria o post se o recurso for 'posts' ou 'combined'
          post = Post.create!(title: title.strip, content: content.strip, user: user)
          
          # Cria as tags associadas ao post
          tags.each do |tag|
            post.tags.create!(name: tag)
          end
        end

        if resource_type == "tags" || resource_type == "combined"
          # Cria as tags se o recurso for 'tags' ou 'combined'
          tags.each do |tag|
            Tag.find_or_create_by!(name: tag)
          end
        end
      end

    rescue ActiveRecord::RecordInvalid => e
      # Log de erro caso a criação de algum registro falhe
      logger.error "Erro ao processar linha: #{line.strip}. Detalhes: #{e.message}"
    end
  end
end
