require 'rails_helper'

RSpec.describe Like, type: :model do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost_now) }
  let!(:like) { Like.create(user_id: user.id, micropost_id: micropost.id) }

  it "user_id, micropost_id があれば有効な状態であること" do
    expect(like).to be_valid
  end

  it "user_id がなければ無効な状態であること" do
    like.user_id = nil
    like.valid?
    expect(like.errors[:user_id]).to include("を入力してください")
  end

  it "micropost_id がなければ無効な状態であること" do
    like.micropost_id = nil
    like.valid?
    expect(like.errors[:micropost_id]).to include("を入力してください")
  end
end
