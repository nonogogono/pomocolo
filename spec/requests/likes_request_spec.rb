require 'rails_helper'

RSpec.describe "Likes", type: :request do
  let!(:user) { create(:user) }
  let!(:micropost) { create(:micropost_now) }
  let!(:like) { Like.create(user_id: user.id, micropost_id: micropost.id) }

  context "ログインしていない場合" do
    it "create しようとすると、ログインページにリダイレクトされること" do
      expect do
        post likes_path
      end.not_to change(Like, :count)
      is_expected.to redirect_to new_user_session_path
    end

    it "destroy しようとすると、ログインページにリダイレクトされること" do
      expect do
        delete like_path(like)
      end.not_to change(Like, :count)
      is_expected.to redirect_to new_user_session_path
    end
  end
end
