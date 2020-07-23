require 'rails_helper'

RSpec.describe User, type: :model do
  let!(:user) { User.new(name: "Harry Potter", email: "gryffindor@hogwarts.org", password: "nimbus") }

  it "name, email, password があれば有効な状態であること" do
    expect(user).to be_valid
  end

  it "name がなければ無効な状態であること" do
    user.name = nil
    user.valid?
    expect(user.errors[:name]).to include("can't be blank")
  end

  it "email がなければ無効な状態であること" do
    user.email = nil
    user.valid?
    expect(user.errors[:email]).to include("can't be blank")
  end

  it "email が重複していれば無効な状態であること" do
    User.create(name: "Ron Weasley", email: "gryffindor@hogwarts.org", password: "largefamily")
    user_2 = User.new(name: "Hermione Granger", email: "gryffindor@hogwarts.org", password: "brightest")
    user_2.valid?
    expect(user_2.errors[:email]).to include("has already been taken")
  end

  it "password がなければ無効な状態であること" do
    user.password = nil
    user.valid?
    expect(user.errors[:password]).to include("can't be blank")
  end

  it "password があり、6文字以上でなけば無効な状態であること" do
    user.password = "nimbu"
    user.valid?
    expect(user.errors[:password]).to include("is too short (minimum is 6 characters)")
  end

  it "profile が201文字以上であれば無効な状態であること" do
    user.profile = "a" * 200
    expect(user).to be_valid
    user.profile = "a" * 201
    user.valid?
    expect(user.errors[:profile]).to include("is too long (maximum is 200 characters)")
  end
end
