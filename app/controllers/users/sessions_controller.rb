# app/controllers/users/sessions_controller.rb
class Users::SessionsController < Devise::SessionsController
  respond_to :json

  def create
    self.resource = warden.authenticate!(auth_options)
    if resource
      sign_in(resource_name, resource)
      render json: { message: "Login realizado com sucesso" }, status: :ok
    else
      render json: { error: "Credenciais inválidas" }, status: :unauthorized
    end
  end

  def destroy
    signed_out = sign_out(resource_name)
    if signed_out
      render json: { message: "Logout realizado com sucesso" }, status: :ok
    else
      render json: { error: "Erro ao realizar logout" }, status: :internal_server_error
    end
  end
end
