require 'rails_helper'

RSpec.describe "User Registration", type: :request do
  describe "POST /users" do
    it "registra um novo usuário com sucesso" do
      user_params = {
        user: {
          name: Faker::Name.name,
          email: Faker::Internet.email,
          password: 'password123',
          password_confirmation: 'password123'
        }
      }

      post "/users", params: user_params

      expect(User.last.email).to eq(user_params[:user][:email])
    end

    it "não cadastra usuário com dados inválidos" do
      user_params = {
        user: {
          name: "",
          email: "invalid_email",
          password: "short",
          password_confirmation: "mismatch"
        }
      }

      post "/users", params: user_params

      expect(User.count).to eq(0)
    end
  end
end