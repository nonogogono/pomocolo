require 'rails_helper'

RSpec.describe "Tasks", type: :request do
  let!(:user) { create(:user) }
  let!(:taro) { create(:taro) }
  let!(:user_task) { create(:task, user_id: user.id) }
  let!(:taro_task) { create(:task, user_id: taro.id) }

  context "ログインしている場合" do
    before do
      sign_in user
    end

    it "別のユーザーの task を削除しようとすると、timer_path にリダイレクトされること" do
      expect do
        delete task_path(taro_task.id)
      end.not_to change(Task, :count)
      is_expected.to redirect_to timer_path
    end
  end

  context "ログインしていない場合" do
    it "task を作成しようとすると、ログインページにリダイレクトされること" do
      expect do
        post tasks_path, params: { task: { name: "化学" } }
      end.not_to change(Task, :count)
      is_expected.to redirect_to new_user_session_path
    end

    it "task を削除しようとすると、ログインページにリダイレクトされること" do
      expect do
        delete task_path(user_task.id)
      end.not_to change(Task, :count)
      is_expected.to redirect_to new_user_session_path
    end
  end
end
