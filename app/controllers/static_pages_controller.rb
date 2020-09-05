class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.recent.page(params[:page]).per(Constants::FEED_NUM)
      @search_user = User.ransack(params[:q])
      @users = @search_user.result(distinct: true).page(params[:page]).per(Constants::SEARCH_USER_NUM) if params[:q].present?
      @search_micropost = Micropost.ransack(params[:p], search_key: :p)
      @microposts = @search_micropost.result(distinct: true).recent.page(params[:page]).per(Constants::SEARCH_MICROPOST_NUM) if params[:p].present?
    end
  end

  def timer
    @micropost = current_user.microposts.build
    @task = current_user.tasks.build
    @tasks = current_user.tasks.recent
    @last_task = last_task
  end
end
