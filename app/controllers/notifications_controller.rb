class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.includes([:visitor, :visited, :micropost]).where.not(visitor_id: current_user.id).recent.page(params[:page]).per(Constants::NOTIFICATION_NUM)
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)
    end
  end
end
