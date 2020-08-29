class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.recent.page(params[:page]).per(Constants::SHOW_MICROPOST_NUM)
  end

  def following
    @title = "フォロー中"
    @user = User.find(params[:id])
    @users = @user.following.page(params[:page]).per(Constants::SHOW_FOLLOW_NUM)
    render 'show_follow'
  end

  def followers
    @title = "フォロワー"
    @user = User.find(params[:id])
    @users = @user.followers.page(params[:page]).per(Constants::SHOW_FOLLOW_NUM)
    render 'show_follow'
  end
end
