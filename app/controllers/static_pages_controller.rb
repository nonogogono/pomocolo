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
    # micropost 作成
    @micropost = current_user.microposts.build
    @last_task = last_task
    # task 作成, 一覧
    @task = current_user.tasks.build
    @tasks = current_user.tasks.recent
    # task グラフ
    @tasks_today = tasks_day_set(Time.zone.now)
    # Today's task
    @microposts_with_task_today = microposts_with_task(Time.zone.now)
  end

  def week
    @task_names_this_week = task_names_term_distinct(Time.zone.now.all_week)
    @tasks_this_week = tasks_week_set(Time.zone.now)
  end

  def month
    @task_names_this_month = task_names_term_distinct(Time.zone.now.all_month)
    @tasks_this_month = tasks_month_set(Time.zone.now)
  end
end
