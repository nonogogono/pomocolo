class MicropostsController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "投稿されました！"
      if @micropost.task.blank?
        redirect_to root_url
      else
        redirect_to timer_url
      end
    else
      @feed_items = current_user.feed.includes([:user]).recent.page(params[:page]).per(Constants::FEED_NUM)
      @search_user = User.ransack(params[:q])
      @users = @search_user.result(distinct: true).page(params[:page]).per(Constants::SEARCH_USER_NUM) if params[:q].present?
      @search_micropost = Micropost.ransack(params[:p], search_key: :p)
      @microposts = @search_micropost.result(distinct: true).includes([:user]).recent.page(params[:page]).per(Constants::SEARCH_MICROPOST_NUM) if params[:p].present?

      if @micropost.task.blank?
        render 'static_pages/home'
      else
        # micropost 作成
        @last_task = last_task
        # task 作成, 一覧
        @task = current_user.tasks.build
        @tasks = current_user.tasks.recent
        # task グラフ
        @tasks_today = tasks_day_set(Time.zone.now)
        # Today's task
        @microposts_with_task_today = microposts_with_task(Time.zone.now)

        @show_modal = true
        render 'static_pages/timer'
      end
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿を削除しました！"
    if request.referer.include?('microposts')
      redirect_to root_url
    else
      redirect_back(fallback_location: root_url)
    end
  end

  private

  def micropost_params
    params.require(:micropost).permit(:content, :task, :task_time)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
