require 'rails_helper'

RSpec.describe Micropost, type: :model do
  let!(:micropost) { build(:micropost_now) }

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
end
