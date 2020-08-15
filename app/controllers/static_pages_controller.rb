class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.recent.page(params[:page]).per(10)
    end
  end

  def timer
  end
end
