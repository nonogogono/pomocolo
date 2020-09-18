require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:user) { create(:user) }
  let!(:taro) { create(:taro) }
  let!(:cameron) { create(:cameron) }
  let!(:john) { create(:user, name: "John") }
  let!(:micropost) { build(:micropost_now, user_id: user.id) }
  let!(:micropost_taro) { create(:micropost_taro, user_id: taro.id) }
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

  it "micropost が削除されたらその like に関連する notification も削除されること" do
    micropost_taro.notify_like(user)
    expect { micropost_taro.destroy }.to change(Notification, :count).by(-1)
  end

  it "micropost が削除されたらその comment に関連する notification も削除されること" do
    comment = user.comments.create(micropost_id: micropost_taro.id, content: "勢いは大事")
    micropost_taro.notify_comment(user, comment.id)
    expect { micropost_taro.destroy }.to change(Notification, :count).by(-1)
  end

  it "like と unlike の動作が正しいこと" do
    micropost.save
    expect(micropost.like?(user)).to eq false
    micropost.like(user)
    expect(micropost.like?(user)).to eq true
    micropost.unlike(user)
    expect(micropost.like?(user)).to eq false
  end

  it "notify_like で 未いいねであれば notification が増えること" do
    expect { micropost_taro.notify_like(user) }.to change(Notification, :count).by(1)
  end

  it "notify_like で 既にいいね済であれば notification は変わらないこと" do
    micropost_taro.notify_like(user)
    expect { micropost_taro.notify_like(user) }.not_to change(Notification, :count)
  end

  it "notify_like で 自分の投稿へのいいねは通知済となること" do
    micropost.save
    micropost.notify_like(user)
    notification = user.active_notifications.find_by(micropost_id: micropost.id, visited_id: user.id, action: 'like')
    expect(notification.checked).to eq true
  end

  it "notify_comment で notification が増えること" do
    comment = user.comments.create(micropost_id: micropost_taro.id, content: "他人へのコメント")
    expect { micropost_taro.notify_comment(user, comment.id) }.to change(Notification, :count).by(1)
  end

  it "notify_comment で 自分以外でまだ誰もコメントしていない場合は、投稿者に通知を送ること" do
    comment = user.comments.create(micropost_id: micropost_taro.id, content: "他人へのコメント")
    micropost_taro.notify_comment(user, comment.id)
    expect(taro.passive_notifications.last.comment.content).to eq "他人へのコメント"
  end

  it "notify_comment で 自分以外から既にコメントがされている場合は、コメントしている全員へ通知を送ること" do
    cameron.comments.create(micropost_id: micropost_taro.id, content: "Cameron のコメント")
    john.comments.create(micropost_id: micropost_taro.id, content: "John のコメント")
    comment_user = user.comments.create(micropost_id: micropost_taro.id, content: "user のコメント")
    micropost_taro.notify_comment(user, comment_user.id)
    [cameron, john].each do |receiver|
      expect(receiver.passive_notifications.last.comment.content).to eq "user のコメント"
    end
  end

  it "save_notification_comment で自分の投稿へのコメントは通知済となること" do
    micropost.save
    comment = user.comments.create(micropost_id: micropost.id, content: "自分へのコメント")
    micropost.notify_comment(user, comment.id)
    notification = user.active_notifications.find_by(micropost_id: micropost.id, comment_id: comment.id, visited_id: user.id, action: 'comment')
    expect(notification.checked).to eq true
  end
end
