class User < ApplicationRecord
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :microposts, dependent: :destroy

  def self.guest
    find_or_create_by!(email: "guest@example.com") do |user|
      user.name = "guest"
      user.password = SecureRandom.urlsafe_base64
      # user.confirmed_at = Time.now
    end
  end

  def feed
    Micropost.where("user_id = ?", id)
  end
end
