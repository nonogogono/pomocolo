require 'rails_helper'

RSpec.describe "Microposts", type: :request do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost_now) }
  let!(:micropost_taro) { create(:micropost_taro) }

  context "ログインしている場合" do
    before do
      sign_in user
    end

    it "別のユーザーの micropost を削除しようとすると、root にリダイレクトされること" do
      expect do
        delete micropost_path(micropost_taro.id)
      end.not_to change(Micropost, :count)
      is_expected.to redirect_to root_path
    end
  end

  context "ログインしていない場合" do
    it "micropost を投稿しようとすると、ログインページにリダイレクトされること" do
      expect do
        post microposts_path, params: { micropost: { content: "縄跳び" } }
      end.not_to change(Micropost, :count)
      is_expected.to redirect_to new_user_session_path
    end

    it "micropost を削除しようとすると、ログインページにリダイレクトされること" do
      expect do
        delete micropost_path(micropost.id)
      end.not_to change(Micropost, :count)
      is_expected.to redirect_to new_user_session_path
    end
  end
end
