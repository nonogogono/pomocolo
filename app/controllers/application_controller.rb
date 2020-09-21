class ApplicationController < ActionController::Base
  before_action :authenticate_user!, except: :home
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    user_path(resource)
  end

  def after_sign_out_path_for(resource)
    root_path
  end

  def check_guest
    email = resource&.email || params[:user][:email].downcase
    if email == 'guest@example.com'
      redirect_to root_path, alert: 'ゲストユーザーの変更・削除はできません'
    end
  end

  def last_task
    last_micropost_with_task = current_user.microposts.recent.where.not(task: nil).first
    last_micropost_with_task.present? ? last_micropost_with_task.task : nil
  end

  # 当日のタスクあり mircopost を返す
  def microposts_with_task(moment)
    current_user.microposts.where(created_at: moment.all_day).where.not(task: nil).recent.page(params[:page]).per(Constants::SHOW_MICROPOST_NUM)
  end

  # 当日に作成された micropost からそれぞれの [task, task_time] を返す
  def tasks_day(moment)
    microposts_day = current_user.microposts.where(created_at: moment.all_day)
    microposts = microposts_day.where.not(task: nil).select(:task).distinct

    task_names = []
    microposts.each do |micropost|
      task_names.append(micropost.task)
    end

    tasks_day = []
    task_names.each do |task_name|
      task_time = microposts_day.where(task: task_name).sum(:task_time)
      tasks_day.append([task_name, task_time])
    end

    return tasks_day
  end

  # tasks_day の 全タスクの合計時間を返す
  def tasks_total_time(tasks_day)
    total_time = 0
    tasks_day.each do |task, time|
      total_time += time
    end

    return total_time
  end

  # tasks_day　に 引数の時間と tasks_total_time を合わせて返す
  def tasks_day_set(moment)
    each_task = tasks_day(moment)
    total_time = tasks_total_time(each_task)

    return [moment, total_time, each_task]
  end

  # 週それぞれの日毎に tasks_day_set を取得
  def tasks_week_set(moment)
    tasks_each_day = []
    for n in 0..6 do
      moment_n = moment.beginning_of_week.days_since(n)
      tasks_each_day.append(tasks_day_set(moment_n))
    end

    return tasks_each_day
  end

  # 月それぞれの日毎に tasks_day_set を取得
  def tasks_month_set(moment)
    tasks_each_day = []
    for n in 0..moment.end_of_month.day - 1 do
      moment_n = moment.beginning_of_month.days_since(n)
      tasks_each_day.append(tasks_day_set(moment_n))
    end

    return tasks_each_day
  end

  # 引数の期間で重複なしの task_name を返す
  def task_names_term_distinct(term)
    microposts = current_user.microposts.where(created_at: term).where.not(task: nil).select(:task).distinct

    task_names_week = []
    microposts.each do |micropost|
      task_names_week.append(micropost.task)
    end

    return task_names_week
  end

  # 期間内の全タスクの合計時間を返す
  def tasks_total_time_term(tasks_term_set)
    total_time_term = 0
    tasks_term_set.each do |moment, total_time, each_task|
      total_time_term += total_time
    end

    return total_time_term
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :profile, :task_time, :break_time])
  end
end
