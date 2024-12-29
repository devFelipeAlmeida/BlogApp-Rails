require 'rails_helper'

RSpec.describe "Posts", type: :request do
  let!(:user) { create(:user) }  # Criando um usuário para os testes

  describe "POST /posts" do
    context "quando o usuário está logado" do
      before do
        sign_in user  # Simula o login do usuário
      end

      it "cria um novo post com sucesso e retorna JSON" do
        post_params = { post: { title: 'Título', content: 'Conteúdo' } }

        post posts_path, params: post_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(201)  # Status HTTP Created
        expect(json_response["message"]).to eq("Post criado com sucesso")
        expect(json_response["post"]["title"]).to eq('Título')
        expect(json_response["post"]["content"]).to eq('Conteúdo')
      end

      it "não cria um post com dados inválidos e retorna JSON" do
        post_params = { post: { title: '', content: 'Conteúdo' } }

        post posts_path, params: post_params, as: :json

        json_response = JSON.parse(response.body)
        expect(response.status).to eq(422)  # Status HTTP Unprocessable Entity
        expect(json_response["title"]).to include("can't be blank")
      end
    end

    context "quando o usuário não está logado" do
      it "retorna erro JSON com mensagem apropriada" do
        post_params = { post: { title: 'Título', content: 'Conteúdo' } }
    
        post posts_path, params: post_params, as: :json
    
        json_response = JSON.parse(response.body)
        expect(response.status).to eq(401)  # Status HTTP Unauthorized
        expect(json_response["error"]).to eq("Apenas usuários logados podem criar post.")
      end
    end
  end
end
