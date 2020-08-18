require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { User.new(name: "Harry Potter", email: "gryffindor@hogwarts.org", password: "nimbus") }

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
    User.create(name: "Ron Weasley", email: "gryffindor@hogwarts.org", password: "largefamily")
    user_2 = User.new(name: "Hermione Granger", email: "gryffindor@hogwarts.org", password: "brightest")
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
end
