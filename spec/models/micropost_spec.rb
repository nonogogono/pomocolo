require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:user) { create(:user) }
  let!(:micropost) { build(:micropost_now) }
  let!(:like) { Like.create(user_id: user.id, micropost_id: micropost.id) }

  it "user_id, content があれば有効な状態であること" do
    expect(micropost).to be_valid
  end

  it "user_id がなければ無効な状態であること" do
    micropost.user_id = nil
    micropost.valid?
    expect(micropost.errors[:user_id]).to include("を入力してください")
  end

  it "content がなければ無効な状態であること" do
    micropost.content = " "
    micropost.valid?
    expect(micropost.errors[:content]).to include("を入力してください")
  end

  it "content が201文字以上であれば無効な状態であること" do
    micropost.content = "a" * 200
    expect(micropost).to be_valid
    micropost.content = "a" * 201
    micropost.valid?
    expect(micropost.errors[:content]).to include("は200文字以内で入力してください")
  end

  it "microsoft が削除されたらその comment も削除されること" do
    micropost.save
    user.comments.create(micropost_id: micropost.id, content: "勢いは大事")
    expect { micropost.destroy }.to change(Comment, :count).by(-1)
  end

  it "micropost が削除されたらその like も削除されること" do
    micropost.save
    Like.create(user_id: user.id, micropost_id: micropost.id)
    expect { micropost.destroy }.to change(Like, :count).by(-1)
  end

  it "like と unlike の動作が正しいこと" do
    micropost.save
    expect(micropost.like?(user)).to eq false
    micropost.like(user)
    expect(micropost.like?(user)).to eq true
    micropost.unlike(user)
    expect(micropost.like?(user)).to eq false
  end
end
