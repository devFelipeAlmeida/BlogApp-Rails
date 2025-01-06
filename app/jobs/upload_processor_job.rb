class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(blob_id, user_id)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    return if blob.nil?

    begin
      file_data = blob.download
    rescue => e
      return
    end

    tempfile = Tempfile.new(['uploaded_file', '.txt'])
    tempfile.binmode
    tempfile.write(file_data)
    tempfile.rewind

    begin
      process_file(tempfile.path, user_id)
    rescue => e
    ensure
      tempfile.close
      tempfile.unlink
    end
  end

  private

  def process_file(file_path, user_id)
    user = User.find(user_id)

    File.readlines(file_path).each do |line|
      title, content, tags = line.strip.split("|")
      next unless title.present? && content.present?

      tags = tags.present? ? tags.split(",").map(&:strip) : []

      ActiveRecord::Base.transaction do
        post = Post.create!(title: title.strip, content: content.strip, user: user)

        tags.each do |tag_name|
          Tag.create!(name: tag_name, post_id: post.id)
        end
      end
    rescue ActiveRecord::RecordInvalid => e
      Rails.logger.error "Erro ao processar linha: #{line.strip}. Detalhes: #{e.message}"
    end
  end
end
