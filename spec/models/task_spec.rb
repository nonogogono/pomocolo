require 'rails_helper'

RSpec.describe Task, type: :model do
  let!(:user) { create(:user) }
  let!(:taro) { create(:taro) }
  let!(:task_now) { build(:task, user_id: user.id) }
  let!(:task_1_day_ago) { build(:task, user_id: user.id, created_at: 1.day.ago) }
  let!(:task_another_user) { build(:task, user_id: taro.id, created_at: 2.days.ago) }

  it "user_id, name があれば有効な状態であること" do
    expect(task_now).to be_valid
  end

  it "user_id がなければ無効な状態であること" do
    task_now.user_id = nil
    task_now.valid?
    expect(task_now.errors[:user_id]).to include("を入力してください")
  end

  it "name がなければ無効な状態であること" do
    task_now.name = " "
    task_now.valid?
    expect(task_now.errors[:name]).to include("を入力してください")
  end

  it "name が51文字以上であれば無効な状態であること" do
    task_now.name = "a" * 50
    expect(task_now).to be_valid
    task_now.name = "a" * 51
    task_now.valid?
    expect(task_now.errors[:name]).to include("は50文字以内で入力してください")
  end

  it "ユーザーが既に同名のタスクを作成していたら無効であること" do
    task_1_day_ago.save
    expect(task_1_day_ago).to be_valid
    task_now.save
    task_now.valid?
    expect(task_now.errors[:name]).to include("はすでに存在します")
  end

  it "タスク名が重複していても、別のユーザーが作成したのであれば有効であること" do
    task_another_user.save
    expect(task_another_user).to be_valid
    task_now.save
    expect(task_now).to be_valid
  end
end
