class StaticPagesController < ApplicationController
  before_action :home_tab_contents, only: :home

  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
    end
  end

  def timer
  end
end
