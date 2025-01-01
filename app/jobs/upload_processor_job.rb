# app/jobs/upload_processor_job.rb
class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(file_path, resource_type, user_id)
    user = User.find(user_id)
  
    Rails.logger.info "Tentando abrir o arquivo: #{file_path}"
  
    # Verifique se o arquivo realmente existe antes de tentar processá-lo
    if File.exist?(file_path)
      Rails.logger.info "Arquivo encontrado, processando..."
      
      # Processar o arquivo de maneira otimizada
      File.readlines(file_path).each do |line|
        title, content, tags = line.split("|")
        next unless title.present? && content.present? && tags.present?
  
        tags = tags.split(",").map(&:strip)
  
        ActiveRecord::Base.transaction do
          if resource_type == "posts" || resource_type == "combined"
            post = Post.create!(title: title.strip, content: content.strip, user: user)
            tags.each do |tag|
              post.tags.create!(name: tag)
            end
          end
  
          if resource_type == "tags" || resource_type == "combined"
            tags.each do |tag|
              Tag.find_or_create_by!(name: tag)
            end
          end
        end
      rescue ActiveRecord::RecordInvalid => e
        logger.error "Erro ao processar linha: #{line.strip}. Detalhes: #{e.message}"
      end
    else
      Rails.logger.error "Erro: Arquivo não encontrado no caminho #{file_path}"
    end
  end
  
end
