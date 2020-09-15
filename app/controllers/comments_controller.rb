class CommentsController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @comment = current_user.comments.build(comment_params)
    @micropost = Micropost.find(params[:micropost_id])
    if @comment.save
      flash[:success] = "コメントされました！"
      redirect_to micropost_url(@micropost)
    else
      @comments = @micropost.comments.includes([:user]).recent.page(params[:page]).per(Constants::COMMENT_NUM)
      render 'microposts/show'
    end
  end

  def destroy
    @micropost = Micropost.find(params[:micropost_id])
    @comment.destroy
    flash[:success] = "コメントを削除しました！"
    redirect_to micropost_url(@micropost)
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :micropost_id)
  end

  def correct_user
    @comment = current_user.comments.find_by(id: params[:id], micropost_id: params[:micropost_id])
    redirect_to micropost_url(params[:micropost_id]) if @comment.nil?
  end
end
