require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }

  describe "POST /posts" do
    context "quando o usuário está logado" do
      before do
        sign_in user
      end

      it "cria um novo post com sucesso e retorna JSON" do
        post_params = { post: { title: 'Título', content: 'Conteúdo' } }

        post posts_path, params: post_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(201)
        expect(json_response["message"]).to eq("Post criado com sucesso")
        expect(json_response["post"]["title"]).to eq('Título')
        expect(json_response["post"]["content"]).to eq('Conteúdo')
      end

      it "não cria um post com dados inválidos e retorna JSON" do
        post_params = { post: { title: '', content: 'Conteúdo' } }
      
        post posts_path, params: post_params, as: :json
      
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)
        expect(json_response["title"]).to include("não pode ficar em branco")
      end
    end

    context "quando o usuário não está logado" do
      it "retorna erro JSON com mensagem apropriada" do
        post_params = { post: { title: 'Título', content: 'Conteúdo' } }
    
        post posts_path, params: post_params, as: :json
    
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(401)
        expect(json_response["error"]).to eq("Você não tem permissão para realizar essa ação.")
      end
    end
  end
end
