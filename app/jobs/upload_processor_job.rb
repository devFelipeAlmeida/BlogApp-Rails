class UploadProcessorJob < ApplicationJob
  queue_as :default

  def perform(file_path)
    File.readlines(file_path).each do |line|
      title, content, tags = line.strip.split('|')
      post = Post.create!(title: title, content: content)
      tags.split(',').each do |tag_name|
        tag = Tag.find_or_create_by!(name: tag_name.strip)
        post.tags << tag
      end
    end
  end
end
