require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  let!(:user) { create(:user) }

  describe "GET #home" do
    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get root_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get root_path
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #timer" do
    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get timer_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get timer_path
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #week" do
    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get week_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get week_path
        is_expected.to redirect_to new_user_session_path
      end
    end
  end

  describe "GET #month" do
    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get month_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get month_path
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
