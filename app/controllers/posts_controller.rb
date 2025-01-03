class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authenticate_user!, except: %i[index show]
  before_action :authorize_user, only: %i[edit update destroy]

  def index
    if params[:search].present?
      @posts = Post.joins(:tags)
                   .where("posts.title ILIKE ? OR posts.content ILIKE ? OR tags.name ILIKE ?",
                          "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                   .distinct
                   .order(created_at: :desc)
                   .page(params[:page]).per(3)
    elsif params[:tag].present?
      @posts = Post.joins(:tags)
                   .where("tags.name ILIKE ?", params[:tag])
                   .order(created_at: :desc)
                   .page(params[:page]).per(3)
    else
      @posts = Post.all
                   .order(created_at: :desc)
                   .page(params[:page]).per(3)
    end

    respond_to do |format|
      format.html
      format.turbo_stream
    end
  end

  def show
    @comment = Comment.new
  end

  def new
    if current_user.nil?
      redirect_to root_path, alert: t("flash.posts.not_authenticated")
    else
      @post = Post.new
    end
  end

  def edit
    render json: @post
  end

  def create
    if current_user.nil?
      respond_to do |format|
        format.html { redirect_to root_path, alert: t("flash.posts.not_authenticated") }
        format.json { render json: { error: "Apenas usuários logados podem criar post." }, status: :unauthorized }
      end
      return
    end

    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        if params[:post][:tags].present?
          custom_tags = params[:post][:tags].split(",").map(&:strip).uniq
          custom_tags.each do |tag_name|
            tag = Tag.find_or_create_by(name: tag_name, post_id: @post.id)
            @post.tags << tag unless @post.tags.include?(tag)
          end
        end

        format.html { redirect_to @post, notice: t("flash.posts.created") }
        format.json { render json: { message: "Post criado com sucesso", post: @post }, status: :created }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to root_path, alert: t("flash.posts.not_authenticated") }
        format.json { render json: { error: "Apenas usuários logados podem atualizar post." }, status: :unauthorized }
      end
      return
    end

    respond_to do |format|
      if @post.update(post_params)
        if params[:post][:tags].present?
          custom_tags = params[:post][:tags].split(",").map(&:strip).uniq
          tags = custom_tags.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
          @post.tags = tags
        end

        format.html { redirect_to @post, notice: t("flash.posts.updated") }
        format.json { render json: { message: "Post atualizado com sucesso", post: @post }, status: :ok }
      else
        format.html { render :edit, alert: t("flash.posts.not_updated") }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: t("flash.posts.deleted") }
      format.json { render json: { message: "Post excluído com sucesso" }, status: :ok }
    end
  end

  private

  def authorize_user
    unless current_user == @post.user
      respond_to do |format|
        format.html { redirect_to root_path, alert: t("flash.posts.not_permission")}
        format.json { render json: { error: "Você não tem permissão para realizar essa ação." }, status: :forbidden }
      end
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :content)
  end
end
