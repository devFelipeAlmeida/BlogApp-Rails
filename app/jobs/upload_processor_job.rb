class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(blob_id, user_id)
    blob = ActiveStorage::Blob.find_by(id: blob_id)
    return unless blob

    file_data = blob.download
    return unless file_data

    tempfile = Tempfile.new(['uploaded_file', '.txt'])
    tempfile.binmode
    tempfile.write(file_data)
    tempfile.rewind

    process_file(tempfile.path, user_id)

    tempfile.close
    tempfile.unlink
  end

  private

  def process_file(file_path, user_id)
    user = User.find(user_id)

    File.readlines(file_path).each do |line|
      next unless line.include?("|")

      title, content, tags = line.strip.split("|")
      next unless title.present? && content.present?

      tags = tags.present? ? tags.split(",").map(&:strip) : []

      ActiveRecord::Base.transaction do
        post = Post.create!(title: title.strip, content: content.strip, user: user)

        tags.each do |tag_name|
          Tag.create!(name: tag_name, post_id: post.id)
        end
      end
    end
  end
end
