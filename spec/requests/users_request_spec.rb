require 'rails_helper'

RSpec.describe "Users", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }
    let!(:micropost_now) { build(:micropost_now) }
    let!(:micropost_2hours_ago) { build(:micropost_2hours_ago) }

    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get user_path(user)
        expect(response).to have_http_status(200)
      end

      it "最新の micropost が最初になること" do
        micropost_now.save
        micropost_2hours_ago.save
        expect(micropost_now).to eq Micropost.first
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get user_path(user)
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #following #followers" do
    let!(:user) { create(:user) }
    let!(:taro) { create(:taro) }
    let!(:cameron) { create(:cameron) }

    before do
      user.follow(taro)
      cameron.follow(user)
    end

    context "ログインしている場合" do
      before { sign_in user }

      it "フォロー中リストのリクエストが成功すること" do
        get following_user_path(user)
        expect(response).to have_http_status(200)
      end

      it "フォロワーリストのリクエストが成功すること" do
        get followers_user_path(user)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "フォロー中リストへアクセスしようとすると、ログインページにリダイレクトされること" do
        get following_user_path(user)
        is_expected.to redirect_to new_user_session_path
      end

      it "フォロワーリストへアクセスしようとすると、ログインページにリダイレクトされること" do
        get followers_user_path(user)
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
