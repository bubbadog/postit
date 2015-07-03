class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find_by slug: params[:post_id] #params change when nested
    @comment = @post.comments.build(params.require(:comment).permit(:body))
    @comment.creator = current_user #changed from User.first once had authentication established

    if @comment.save
      flash[:notice] = "Your comment was added"
      redirect_to post_path(@post)
    else
      render 'posts/show'
    end
  end

  def vote
    @comment = Comment.find(params[:id])
    @vote = Vote.create(vote: params[:vote], creator: current_user, voteable: @comment)

    respond_to do |format|
      format.html do  # { redirect_to :back, notice: "Your vote was counted"}
        if vote.valid?
          flash[:notice] = 'Your vote was counted.'
        else
          flash[:error] = 'You can only vote once on a comment.'
        end
          redirect_to :back
      end
      format.js
    end
  end
end
