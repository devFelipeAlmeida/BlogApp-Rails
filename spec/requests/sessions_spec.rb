require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user, email: 'test@example.com', password: 'password123') }

  describe "POST /users/sign_in" do
    it "logs in the user successfully and returns a success message" do
      post user_session_path, params: { user: { email: 'test@example.com', password: 'password123' } }

      expect(response).to have_http_status(303)

      follow_redirect!
    end

    it "does not log in with incorrect credentials and returns an error message" do
      post user_session_path, params: { user: { email: 'wrong@example.com', password: 'wrongpassword' } }
    
      expect(response).to have_http_status(422)
    
      expect(response.body).to include("E-mail ou senha inválidos.")
    end
  end
end
