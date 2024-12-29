require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }  # Criando um usuário para os testes
  let!(:post) { create(:post, user: user) }  # Criando um post para o usuário

  describe "DELETE /posts/:id" do
    context "quando o usuário está logado" do
      before do
        sign_in user  # Simula o login do usuário
      end

      it "deleta um post com sucesso e retorna uma resposta JSON" do
        # Realiza a requisição DELETE, esperando resposta JSON
        expect {
          delete post_path(post), as: :json
        }.to change(Post, :count).by(-1)  # Espera que o número de posts diminua em 1

        # Verifica a resposta JSON
        json_response = JSON.parse(response.body)
        expect(json_response).to include("message" => "Post excluído com sucesso")  # Confirma a mensagem no JSON

        # Verifica o status HTTP
        expect(response.status).to eq(200)  # Espera um status HTTP 200 (OK)
      end
    end


    context "quando o usuário não está logado" do
      it "não permite excluir o post e retorna uma mensagem JSON de erro" do
        # Tenta realizar a requisição DELETE como JSON
        delete post_path(post), as: :json

        # Verifica se a resposta é JSON e contém a mensagem esperada
        json_response = JSON.parse(response.body)
        expect(json_response).to include("error" => "Você não tem permissão para realizar essa ação.")

        # Verifica o status HTTP
        expect(response.status).to eq(403)  # Espera um status HTTP 403 (Forbidden)
      end
    end
  end
end
