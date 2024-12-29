class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]
  before_action :authorize_user, only: %i[edit update destroy]

  # GET /posts or /posts.json
  def index
    if params[:search].present?
      # Buscando posts com tags personalizadas ou padrão sem diferenciar maiúsculas e minúsculas
      @posts = Post.joins(:tags)
                   .where("posts.title ILIKE ? OR posts.content ILIKE ? OR tags.name ILIKE ?",
                          "%#{params[:search]}%", "%#{params[:search]}%", "%#{params[:search]}%")
                   .distinct
                   .page(params[:page]).per(3)
    elsif params[:tag].present?
      # Filtro por tag específica sem diferenciar maiúsculas e minúsculas
      @posts = Post.joins(:tags).where("tags.name ILIKE ?", params[:tag]).page(params[:page]).per(3)
    else
      # Exibe todos os posts
      @posts = Post.all.page(params[:page]).per(3)
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
      redirect_to root_path, alert: "Apenas usuários logados podem criar post."
    else
      @post = Post.new
    end
  end

  # GET /posts/1/edit
  def edit
    # Não é necessário renderizar a visão em APIs, então apenas retornamos o post
    render json: @post
  end

  # POST /posts or /posts.json
  def create
    if current_user.nil?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Apenas usuários logados podem criar post." }
        format.json { render json: { error: "Apenas usuários logados podem criar post." }, status: :unauthorized }
      end
      return
    end

    @post = current_user.posts.build(post_params)

    respond_to do |format|
      if @post.save
        # Adicionar tags padrão associadas ao post
        if params[:post][:default_tag_ids].present?
          default_tags = Tag.where(id: params[:post][:default_tag_ids])
          @post.tags << default_tags
        end

        # Criar novas tags personalizadas
        if params[:post][:tags].present?
          custom_tags = params[:post][:tags].split(",").map(&:strip).uniq
          custom_tags.each do |tag_name|
            @post.tags.create(name: tag_name)
          end
        end

        format.html { redirect_to @post, notice: "Post criado com sucesso." }
        format.json { render json: { message: "Post criado com sucesso", post: @post }, status: :created }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end


  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    # Verifica se o usuário está autenticado
    unless user_signed_in?
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Apenas usuários logados podem atualizar posts." }
        format.json { render json: { error: "Apenas usuários logados podem atualizar post." }, status: :unauthorized }
      end
      return
    end

    # Lógica para atualizar o post
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render json: { message: "Post atualizado com sucesso", post: @post }, status: :ok }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end



  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy!

    respond_to do |format|
      format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
      format.json { render json: { message: "Post was successfully destroyed" }, status: :ok }
    end
  end

  private

  def authorize_user
    unless current_user == @post.user
      respond_to do |format|
        format.html { redirect_to root_path, alert: "Você não tem permissão para realizar essa ação." }
        format.json { render json: { error: "Você não tem permissão para realizar essa ação." }, status: :forbidden }
      end
    end
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content)
  end
end
