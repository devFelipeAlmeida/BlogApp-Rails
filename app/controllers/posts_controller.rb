class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  # GET /posts or /posts.json
  def index
    if params[:search].present?
      # Buscando posts com tags customizadas
      @posts = Post.joins(:tags)
                   .where("posts.title ILIKE ? OR posts.content ILIKE ? OR tags.name ILIKE ?",
                          "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                   .distinct
                   .order(created_at: :desc) # Ordena os posts por data de criação em ordem decrescente
                   .page(params[:page]).per(3)
    elsif params[:tag].present?
      # Filtro por tag específica
      @posts = Post.joins(:tags)
                   .where("tags.name ILIKE ?", params[:tag])
                   .order(created_at: :desc) # Ordena os posts por data de criação em ordem decrescente
                   .page(params[:page]).per(3)
    else
      # Exibe todos os posts
      @posts = Post.all
                   .order(created_at: :desc) # Ordena os posts por data de criação em ordem decrescente
                   .page(params[:page]).per(3)
    end

    respond_to do |format|
      format.html # Para o caso de não ser uma requisição Turbo
      format.turbo_stream # Para a requisição Turbo
    end
  end

  # GET /posts/1 or /posts/1.json
  def show
    @comment = Comment.new
  end

  # GET /posts/new
  def new
    if current_user.nil?
      redirect_to root_path, alert: t("flash.posts.not_authenticated")
    else
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
    render json: @post
  end

  # POST /posts or /posts.json
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
        # Verificando se as tags estão presentes e associando ao post
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

  # PATCH/PUT /posts/1 or /posts/1.json
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
        # Atualizar tags customizadas associadas
        if params[:post][:tags].present?
          custom_tags = params[:post][:tags].split(",").map(&:strip).uniq
          tags = custom_tags.map { |tag_name| Tag.find_or_create_by(name: tag_name) }
          @post.tags = tags # Reassocia as tags ao post (remover as antigas e adicionar as novas)
        end

        format.html { redirect_to @post, notice: t("flash.posts.updated") }
        format.json { render json: { message: "Post atualizado com sucesso", post: @post }, status: :ok }
      else
        format.html { render :edit, alert: t("flash.posts.not_updated") }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
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

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Somente permite os parâmetros confiáveis
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
