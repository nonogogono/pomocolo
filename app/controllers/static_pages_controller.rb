class StaticPagesController < ApplicationController
  before_action :home_tab_contents, only: :home

  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
    end
  end

  def timer
    @micropost = current_user.microposts.build
    @task = current_user.tasks.build
    @tasks = current_user.tasks.recent
    @last_task = last_task
  end
end
