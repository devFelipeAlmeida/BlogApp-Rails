require 'rails_helper'

RSpec.describe "UploadsController", type: :request do
  let(:user) { create(:user) }  # Criando um usuário para testar a ação com autenticação, se necessário
  let(:file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'sample.txt'), 'text/plain') }  # Arquivo de teste
  
  before do
    sign_in user  # Se estiver usando Devise para autenticação
  end

  describe "POST /uploads/process_upload" do
    context "quando o arquivo é válido" do
      it "faz o upload do arquivo e processa o job" do
        expect {
          post process_upload_path, params: { file: file }
        }.to have_enqueued_job(UploadProcessorJob)  # Verifica se o job foi enfileirado

        expect(response).to redirect_to(root_path)  # Verifica se a resposta é um redirecionamento
        follow_redirect!

        expect(flash[:notice]).to eq(I18n.t("flash.posts.upload_sidekiq"))  # Verifica a mensagem de sucesso
      end
    end

    context "quando o arquivo não é válido" do
      let(:invalid_file) { fixture_file_upload(Rails.root.join('spec', 'fixtures', 'files', 'invalid_file.jpg'), 'application/jpg') }

      it "não faz o upload e exibe uma mensagem de erro" do
        post process_upload_path, params: { file: invalid_file }
        
        expect(response).to redirect_to(root_path)  # Verifica o redirecionamento
        follow_redirect!

        expect(flash[:alert]).to eq(I18n.t("flash.posts.not_upload_sidekiq"))  # Verifica a mensagem de erro
      end
    end
  end
end
