class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]

  def index
    @posts = Post.all
  end

  def show; end
  def edit; end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    create_or_delete_posts_tags(@post, params[:post][:tags])

    respond_to do |format|
      if @post.save
        format.html { redirect_to post_url(@post) }
      else
        format.html { render :new }
      end
    end
  end

  def update
    create_or_delete_posts_tags(@post, params[:post][:tags])

    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to post_url(@post) }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
    end
  end

  private
  def create_or_delete_posts_tags(post, tags)
    post.taggables.destroy_all
    tags = tags.strip.split(",")
    tags.split(',').each do |tag|
      post.tags << Tag.find_or_create_by(name: tag)
    end
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def post_params
    params.require(:post).permit(:title, :body, :tags)
  end
end
