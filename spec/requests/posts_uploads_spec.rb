require 'rails_helper'

RSpec.describe "Posts", type: :request do
  before do
    ActiveJob::Base.queue_adapter = :test
  end

  let(:user) { create(:user) } # Crie um usuário de teste
  let(:file) { fixture_file_upload('sample.txt', 'text/plain') } # Arquivo fictício de texto
  let(:invalid_file) { fixture_file_upload('invalid_file.jpg', 'image/jpeg') }

  before do
    sign_in user
  end

  describe 'POST #process_upload' do
    context 'quando o arquivo é válido' do
      it 'enfileira o job de processamento e cria posts' do
        expect(Post.count).to eq(0)

        expect {
          post process_upload_path, params: { file: file }
        }.to have_enqueued_job(UploadProcessorJob).with(
          an_instance_of(String), user.id
        )

        expect(response).to redirect_to(root_path)
        expect(flash[:notice]).to eq(I18n.t("flash.posts.upload_sidekiq"))
      end
    end

    context 'quando o arquivo é inválido' do
      it 'não enfileira o job e exibe uma mensagem de erro' do
        post process_upload_path, params: { file: invalid_file }

        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq(I18n.t("flash.posts.not_upload_sidekiq"))
      end
    end
  end
end
