class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.recent.page(params[:page]).per(10)
  end
end
