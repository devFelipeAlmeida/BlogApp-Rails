class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
    @posts = @user.posts.order(created_at: :desc) # Assumindo que `User` tem muitos `posts`
  end
end
