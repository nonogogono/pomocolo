class User < ApplicationRecord
  validates :name, presence: true
  validates :profile, length: { maximum: 200 }

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable

  has_many :microposts, dependent: :destroy

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
    Micropost.where("user_id = ?", id)
  end
end
