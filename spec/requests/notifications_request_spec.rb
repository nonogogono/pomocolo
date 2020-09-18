require 'rails_helper'

RSpec.describe "Notifications", type: :request do
  describe "GET #index" do
    let!(:user) { create(:user) }

    context "ログインしている場合" do
      before { sign_in user }

      it "リクエストが成功すること" do
        get notifications_path
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get notifications_path
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
