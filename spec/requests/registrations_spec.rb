require 'rails_helper'

RSpec.describe "User Registration", type: :request do
  describe "POST /users" do
    it "registers a new user successfully" do
      user_params = {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      post "/users", params: user_params

      expect(response).to have_http_status(:see_other) # Verifica se redireciona após sucesso
      expect(User.last.email).to eq(user_params[:user][:email]) # Verifica se o usuário foi salvo no banco
    end

    it "does not register a user with invalid data" do
      user_params = {
        user: {
          name: "",
          email: "invalid_email",
          password: "short",
          password_confirmation: "mismatch"
        }
      }

      post "/users", params: user_params

      expect(response).to have_http_status(:unprocessable_entity) # Deve retornar erro de validação
      expect(User.count).to eq(0) # Não deve criar nenhum usuário
    end
  end
end
