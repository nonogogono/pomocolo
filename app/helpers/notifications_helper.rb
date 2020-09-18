module NotificationsHelper
  def unchecked_notifications
    current_user.passive_notifications.where(checked: false).any?
  end

  def micropost_content(notification)
    Micropost.find(notification.micropost_id)&.content
  end

  def comment_content(notification)
    Comment.find(notification.comment_id)&.content
  end
end
