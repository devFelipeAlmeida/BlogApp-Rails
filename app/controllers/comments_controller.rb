class CommentsController < ApplicationController
  before_action :set_post

  # Cria um novo comentário
  def create
    @comment = @post.comments.build(comment_params)
    @comment.user = current_user if user_signed_in? # Associa ao usuário autenticado, se existir

    if @comment.save
      redirect_to @post, notice: "Comentário criado com sucesso."
    else
      redirect_to @post, alert: "Ocorreu um erro ao criar o comentário."
    end
  end

  private

  # Define o post com base no parâmetro :post_id
  def set_post
    @post = Post.find(params[:post_id])
  end

  # Define os parâmetros permitidos para o comentário
  def comment_params
    params.require(:comment).permit(:message) # Somente a mensagem será permitida
  end
end
