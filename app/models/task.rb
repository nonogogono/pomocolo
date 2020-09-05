class Task < ApplicationRecord
  belongs_to :user
  scope :recent, -> { order(created_at: :desc) }
  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 50 }, uniqueness: { scope: :user_id }
end
