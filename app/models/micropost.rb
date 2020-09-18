class Micropost < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :notifications, dependent: :destroy
  scope :recent, -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 200 }

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def like?(user)
    likes.pluck(:user_id).include?(user.id)
  end

  def notify_like(visitor)
    # 既にいいね済であれば何もしない
    temp = Notification.where(["visitor_id = ? and visited_id = ? and micropost_id = ? and action = ? ", visitor.id, user_id, id, 'like'])
    return if temp.present?

    notification = visitor.active_notifications.build(micropost_id: id, visited_id: user_id, action: 'like')
    # 自分の投稿へのいいねは通知済とする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end

  def notify_comment(visitor, comment_id)
    temp_ids = Comment.select(:user_id).where(micropost_id: id).where.not(user_id: visitor.id).distinct
    # 自分以外でまだ誰もコメントしていない場合は、投稿者に通知を送る
    if temp_ids.blank?
      save_notification_comment(visitor, comment_id, user_id)
    # 自分以外から既にコメントがされている場合は、コメントしている全員へ通知を送る
    else
      temp_ids.each do |temp_id|
        save_notification_comment(visitor, comment_id, temp_id[:user_id])
      end
    end
  end

  def save_notification_comment(visitor, comment_id, visited_id)
    notification = visitor.active_notifications.build(micropost_id: id, comment_id: comment_id, visited_id: visited_id, action: 'comment')
    # 自分の投稿へのコメントは通知済とする
    notification.checked = true if notification.visitor_id == notification.visited_id
    notification.save if notification.valid?
  end
end
