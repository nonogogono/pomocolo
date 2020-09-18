class User < ApplicationRecord
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :microposts, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :active_relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :passive_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy
  has_many :active_notifications, class_name: 'Notification', foreign_key: "visitor_id", dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: "visited_id", dependent: :destroy

  # override Devise::Models::Confirmable#send_on_create_confirmation_instructions
  def send_on_create_confirmation_instructions
    generate_confirmation_token! unless @raw_confirmation_token
    send_devise_notification(:confirmation_on_create_instructions, @raw_confirmation_token, {})
  end

  # override Devise::Models::Confirmable#resend_confirmation_instructions
  def resend_confirmation_instructions
    pending_any_confirmation do
      send_on_create_confirmation_instructions
    end
  end

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "guest"
      user.password = SecureRandom.urlsafe_base64
      user.confirmed_at = Time.now
    end
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id) # rubocop:disable Airbnb/RiskyActiverecordInvocation.
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end

  def followers?(other_user)
    followers.include?(other_user)
  end

  def notify_follow(visitor)
    # フォロー済であれば何もしない
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ", visitor.id, id, 'follow'])
    return if temp.present?

    notification = visitor.active_notifications.build(visited_id: id, action: 'follow')
    notification.save if notification.valid?
  end
end
