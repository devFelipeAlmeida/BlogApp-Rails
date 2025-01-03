require 'rails_helper'

RSpec.describe UploadProcessorJob, type: :job do
  let(:file) { fixture_file_upload('sample.txt', 'text/plain') }
  let(:user) { create(:user) }

  it 'uploads posts from a file' do
    expect {
      UploadProcessorJob.perform_now(file.path, user.id)
    }.to change(Post, :count).by(2)
  end
end
