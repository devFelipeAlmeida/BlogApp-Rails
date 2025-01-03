require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }
  let!(:post) { create(:post, user: user) }

  describe "PATCH /posts/:id" do
    context "quando o usuário está logado" do
      before do
        sign_in user
      end

      it "atualiza um post com sucesso e retorna uma resposta JSON" do
        updated_params = { post: { title: 'Título atualizado', content: 'Conteúdo atualizado' } }

        patch post_path(post), params: updated_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(200)
        expect(json_response["message"]).to eq("Post atualizado com sucesso")
        expect(json_response["post"]["title"]).to eq('Título atualizado')
        expect(json_response["post"]["content"]).to eq('Conteúdo atualizado')
      end

      it "não atualiza um post com dados inválidos e retorna erro JSON" do
        updated_params = { post: { title: '', content: 'Conteúdo atualizado' } }

        patch post_path(post), params: updated_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response["title"]).to include("não pode ficar em branco")
      end
    end

    context "quando o usuário não está logado" do
      it "não permite atualizar o post e retorna erro JSON" do
        updated_params = { post: { title: 'Título atualizado', content: 'Conteúdo atualizado' } }

        patch post_path(post), params: updated_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(json_response["error"]).to eq("Você não tem permissão para realizar essa ação.")
      end
    end
  end
end
