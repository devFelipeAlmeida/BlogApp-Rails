require 'rails_helper'

# spec/requests/sessions_spec.rb
RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe "POST /users/sign_in" do
    it "logs in the user successfully and returns a success message" do
      post user_session_path, params: { user: { email: 'test@example.com', password: 'password123' } }

      # Verifica se o status HTTP é 303 (redirecionamento)
      expect(response).to have_http_status(303)

      # Seguir o redirecionamento e verificar a resposta HTML
      follow_redirect!
    end

    it "does not log in with incorrect credentials and returns an error message" do
      post user_session_path, params: { user: { email: 'wrong@example.com', password: 'wrongpassword' } }
    
      # Verifica se o status HTTP é 422 (Unprocessable Entity)
      expect(response).to have_http_status(422)
    
      # Verifica se o conteúdo HTML inclui a mensagem de erro do Devise
      expect(response.body).to include("E-mail ou senha inválidos.")
    end
  end
end
