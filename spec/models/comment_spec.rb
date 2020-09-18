require 'rails_helper'

RSpec.describe Comment, type: :model do
  let!(:user) { create(:user) }
  let!(:micropost_taro) { create(:micropost_taro) }
  let!(:comment) { user.comments.build(micropost_id: micropost_taro.id, content: "太陽の塔みたい") }

  it "user_id, micropost_id, content があれば有効な状態であること" do
    expect(comment).to be_valid
  end

  it "user_id がなければ無効な状態であること" do
    comment.user_id = nil
    comment.valid?
    expect(comment.errors[:user_id]).to include("を入力してください")
  end

  it "micropost_id がなければ無効な状態であること" do
    comment.micropost_id = nil
    comment.valid?
    expect(comment.errors[:micropost_id]).to include("を入力してください")
  end

  it "content がなければ無効な状態であること" do
    comment.content = " "
    comment.valid?
    expect(comment.errors[:content]).to include("を入力してください")
  end

  it "content が201文字以上であれば無効な状態であること" do
    comment.content = "a" * 200
    expect(comment).to be_valid
    comment.content = "a" * 201
    comment.valid?
    expect(comment.errors[:content]).to include("は200文字以内で入力してください")
  end

  it "comment が削除されたら関連する notification も削除されること" do
    comment.save
    micropost_taro.notify_comment(user, comment.id)
    expect { comment.destroy }.to change(Notification, :count).by(-1)
  end
end
