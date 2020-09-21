class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.includes([:user]).recent.page(params[:page]).per(Constants::FEED_NUM)
      @search_user = User.ransack(params[:q])
      @users = @search_user.result(distinct: true).page(params[:page]).per(Constants::SEARCH_USER_NUM) if params[:q].present?
      @search_micropost = Micropost.ransack(params[:p], search_key: :p)
      @microposts = @search_micropost.result(distinct: true).includes([:user]).recent.page(params[:page]).per(Constants::SEARCH_MICROPOST_NUM) if params[:p].present?
    end
  end

  def timer
    # task あり micropost を create 後のみ休憩のダイアログを表示する
    @break_time_on = params[:break_time]
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
    moment = Time.zone.now
    @start_day = moment.beginning_of_week
    @end_day = moment.end_of_week
    @task_names_week = task_names_term_distinct(moment.all_week)
    @tasks_week = tasks_week_set(moment)
    @tasks_total_time_week = to_h_and_m(tasks_total_time_term(@tasks_week))
  end

  def week_specified
    moment = params[:date].in_time_zone
    moment = Time.zone.now if moment.nil?
    @start_day = moment.beginning_of_week
    @end_day = moment.end_of_week
    @task_names_week = task_names_term_distinct(moment.all_week)
    @tasks_week = tasks_week_set(moment)
    @tasks_total_time_week = to_h_and_m(tasks_total_time_term(@tasks_week))
    render :week
  end

  def month
    @moment = Time.zone.now
    @task_names_month = task_names_term_distinct(@moment.all_month)
    @tasks_month = tasks_month_set(@moment)
    @tasks_total_time_month = to_h_and_m(tasks_total_time_term(@tasks_month))
  end

  def month_specified
    @moment = select_time_zone(params[:date])
    @moment = Time.zone.now if @moment.nil?
    @task_names_month = task_names_term_distinct(@moment.all_month)
    @tasks_month = tasks_month_set(@moment)
    @tasks_total_time_month = to_h_and_m(tasks_total_time_term(@tasks_month))
    render :month
  end

  protected

  # minutes を hours, minutes 表記に変換する
  def to_h_and_m(minutes)
    (minutes / 60).to_s + ' h ' + format('%02d', minutes % 60) + " m"
  end

  # date_select タグから time zone を取得する
  def select_time_zone(date)
    year = format('%04d', date["#{Time.zone.today}(1i)"])
    month = format('%02d', date["#{Time.zone.today}(2i)"])
    day = format('%02d', date["#{Time.zone.today}(3i)"])
    (year + '-' + month + '-' + day).in_time_zone
  end
end
