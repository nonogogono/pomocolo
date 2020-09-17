require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { User.new(name: "Harry Potter", email: "gryffindor@hogwarts.org", password: "nimbus", confirmed_at: Time.now) }
  let!(:taro) { create(:taro) }
  let!(:cameron) { create(:cameron) }
  let!(:funassyi) { create(:user, name: "funassyi") }
  let!(:kumamon) { create(:user, name: "kumamon") }
  let!(:relationship) { Relationship.create(follower_id: funassyi.id, followed_id: kumamon.id) }
  let!(:taro_micropost1) { taro.microposts.create!(content: "芸術は爆発だ") }
  let!(:taro_micropost2) { taro.microposts.create!(content: "自分の中に毒を持て") }
  let!(:funassyi_micropost1) { funassyi.microposts.create!(content: " 梨汁ブシャー") }
  let!(:funassyi_micropost2) { funassyi.microposts.create!(content: "ヒャッハー！") }
  let!(:kumaon_micropost1) { kumamon.microposts.create!(content: "うまい うま、います。") }
  let!(:kumamon_micropost2) { kumamon.microposts.create!(content: "阿蘇山という山はない。") }

  it "name, email, password があれば有効な状態であること" do
    expect(user).to be_valid
  end

  it "name がなければ無効な状態であること" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include("が入力されていません")
  end

  it "email がなければ無効な状態であること" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("が入力されていません")
  end

  it "email が重複していれば無効な状態であること" do
    User.create(name: "Ron Weasley", email: "gryffindor@hogwarts.org", password: "largefamily", confirmed_at: Time.now)
    user_2 = User.new(name: "Hermione Granger", email: "gryffindor@hogwarts.org", password: "brightest", confirmed_at: Time.now)
    user_2.valid?
    expect(user_2.errors[:email]).to include("は既に使用されています")
  end

  it "password がなければ無効な状態であること" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include("が入力されていません")
  end

  it "password が6文字未満であれば無効な状態であること" do
    user.password = "a" * 5
    user.valid?
    expect(user.errors[:password]).to include("は6文字以上に設定して下さい")
    user.password = "a" * 6
    expect(user).to be_valid
  end

  it "profile が201文字以上であれば無効な状態であること" do
    user.profile = "a" * 200
    expect(user).to be_valid
    user.profile = "a" * 201
    user.valid?
    expect(user.errors[:profile]).to include("は200文字以下に設定して下さい")
  end

  it "user が削除されたら user が投稿した micropost も削除されること" do
    user.save
    user.microposts.create!(content: "Quidditch Practice")
    expect { user.destroy }.to change(Micropost, :count).by(-1)
  end

  it "user が削除されたら user が作成した task も削除されること" do
    user.save
    user.tasks.create!(name: "簿記３級")
    expect { user.destroy }.to change(Task, :count).by(-1)
  end

  it "user が削除されたら user が作成した comment も削除されること" do
    user.save
    user.comments.create(micropost_id: taro_micropost1.id, content: "勢いは大事")
    expect { user.destroy }.to change(Comment, :count).by(-1)
  end

  it "user が削除されたら user がした like も削除されること" do
    user.save
    taro_micropost1.like(user)
    expect { user.destroy }.to change(Like, :count).by(-1)
  end

  it "フォローとアンフォローの動作が正しいこと" do
    expect(taro.following?(cameron)).to eq false
    expect(cameron.followers?(taro)).to eq false
    taro.follow(cameron)
    expect(taro.following?(cameron)).to eq true
    expect(cameron.followers?(taro)).to eq true
    taro.unfollow(cameron)
    expect(taro.following?(cameron)).to eq false
    expect(cameron.followers?(taro)).to eq false
  end

  it "フォローしている user が削除されたら、関係する relationship も削除されること" do
    expect { funassyi.destroy }.to change(Relationship, :count).by(-1)
  end

  it "フォローされている user が削除されたら。関係する relationship も削除されること" do
    expect { kumamon.destroy }.to change(Relationship, :count).by(-1)
  end

  it "feed は自分自身の micropost を含むこと" do
    funassyi.microposts.each do |post_self|
      expect(funassyi.feed.include?(post_self)).to eq true
    end
  end

  it "feed はフォローしている user の micropost を含むこと" do
    kumamon.microposts.each do |post_following|
      expect(funassyi.feed.include?(post_following)).to eq true
    end
  end

  it "feed はフォローしていない user の micropost は含まないこと" do
    taro.microposts.each do |post_unfollowed|
      expect(funassyi.feed.include?(post_unfollowed)).to eq false
    end
  end
end
