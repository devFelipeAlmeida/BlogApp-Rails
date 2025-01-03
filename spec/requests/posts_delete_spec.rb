require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe "DELETE /posts/:id" do
    context "quando o usuário está logado" do
      before do
        sign_in user
      end

      it "deleta um post com sucesso e retorna uma resposta JSON" do
        expect {
          delete post_path(post), as: :json
        }.to change(Post, :count).by(-1)

        json_response = JSON.parse(response.body)
        expect(json_response).to include("message" => "Post excluído com sucesso")

        expect(response.status).to eq(200)
      end
    end

    context "quando o usuário não está logado" do
      it "não permite excluir o post e retorna uma mensagem JSON de erro" do
        delete post_path(post), as: :json

        json_response = JSON.parse(response.body)
        expect(json_response).to include("error" => "Você não tem permissão para realizar essa ação.")

        expect(response.status).to eq(401)
      end
    end
  end
end
