class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :vote]
  before_action :require_user, except: [:index, :show]
  before_action :require_creator, only: [:edit, :update]

  def index
    @posts = Post.all.sort_by{|x| x.total_votes}.reverse
  end

  def show
    @comment = Comment.new
  end

  def new
    @post = Post.new #submits to create template
  end

  def create
    @post = Post.new(post_params)
    @post.creator = current_user # TODO: changed from User.first once we have authentitcation

    if @post.save
      flash[:notice] = "Your post was created."
      redirect_to posts_path
    else #validation error
      render :new
    end
  end

  def edit; end #submits to update template

  def update

    if @post.update(post_params)
      flash[:notice] = "The post was updated."
      redirect_to posts_path # or post_path(post) - show post path
    else
      render :edit
    end
  end

  def vote
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @post)

    respond_to do |format|
      format.html { redirect_to :back, notice: "Your vote was counted"}
      format.js

    end
    # if vote.valid?
    #   flash[:notice] = 'Your vote was counted.'
    # else
    #   flash[:error] = 'You can only vote once on a post.'
    # end
    # redirect_to :back
  end

  private

  def post_params
    params.require(:post).permit(:title, :url, :description, category_ids: []) # strong parameters, category_ids: [] is syntax for array based parameters
  end

  def set_post
    @post = Post.find_by slug: params[:id]
  end

  def require_creator
    access_denied unless logged_in? and (current_user == @post.creator || current_user.admin?)
  end
end
