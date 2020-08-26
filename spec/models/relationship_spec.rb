require 'rails_helper'

RSpec.describe Relationship, type: :model do
  let!(:taro) { create(:taro) }
  let!(:cameron) { create(:cameron) }
  let!(:relationship) { Relationship.new(follower_id: taro.id, followed_id: cameron.id) }

  it "follower_id と followed_id があれば有効な状態であること" do
    expect(relationship).to be_valid
  end

  it "follower_id がなければ無効な状態であること" do
    relationship.follower_id = nil
    relationship.valid?
    expect(relationship.errors[:follower_id]).to include("を入力してください")
  end

  it "followed_id がなければ無効な状態であること" do
    relationship.followed_id = nil
    relationship.valid?
    expect(relationship.errors[:followed_id]).to include("を入力してください")
  end
end
