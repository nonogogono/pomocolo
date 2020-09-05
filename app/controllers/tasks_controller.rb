class TasksController < ApplicationController
  before_action :correct_user, only: :destroy

  def create
    @task = current_user.tasks.build(task_params)
    if @task.save
      flash[:success] = "タスクを追加しました！"
      redirect_to timer_url
    else
      render 'static_pages/timer'
    end
  end

  def destroy
    @task.destroy
    flash[:success] = "タスクを削除しました！"
    redirect_to timer_url
  end

  private

  def task_params
    params.require(:task).permit(:name)
  end

  def correct_user
    @task = current_user.tasks.find_by(id: params[:id])
    redirect_to timer_url if @task.nil?
  end
end
