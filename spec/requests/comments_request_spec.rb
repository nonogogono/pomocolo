require 'rails_helper'

RSpec.describe "Comments", type: :request do
  let!(:user) { create(:user) }
  let!(:another_user) { create(:user, name: "Another man") }
  let!(:micropost_taro) { create(:micropost_taro) }
  let!(:comment_user) { user.comments.create(micropost_id: micropost_taro.id, content: "太陽の塔みたい") }
  let!(:comment_another_user) { another_user.comments.create(micropost_id: micropost_taro.id, content: "フランスのキャフェで語りあってみたい") }

  context "ログインしている場合" do
    before do
      sign_in user
    end

    it "別のユーザーの comment を削除しようとすると、micropost_url にリダイレクトされること" do
      expect do
        delete micropost_comment_path(micropost_taro.id, comment_another_user.id)
      end.not_to change(Comment, :count)
      is_expected.to redirect_to micropost_url(micropost_taro)
    end
  end

  context "ログインしていない場合" do
    it "comment を作成しようとすると、ログインページにリダイレクトされること" do
      expect do
        post micropost_comments_path(micropost_taro), params: { comment: { user_id: user.id, micropost_id: micropost_taro.id, content: "エッフェル塔みたい" } }
      end.not_to change(Comment, :count)
      is_expected.to redirect_to new_user_session_path
    end

    it "micropost を削除しようとすると、ログインページにリダイレクトされること" do
      expect do
        delete micropost_comment_path(micropost_taro.id, comment_user.id)
      end.not_to change(Comment, :count)
      is_expected.to redirect_to new_user_session_path
    end
  end
end
