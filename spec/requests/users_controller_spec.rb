require 'rails_helper'

RSpec.describe "UsersController", type: :request do
  describe "GET #show" do
    let!(:user) { create(:user) }

    context "ログインしている場合" do
      before do
        sign_in user
      end

      it "リクエストが成功すること" do
        get user_path(user)
        expect(response).to have_http_status(200)
      end
    end

    context "ログインしていない場合" do
      it "ログインページにリダイレクトされること" do
        get user_path(user)
        is_expected.to redirect_to new_user_session_path
      end
    end
  end
end
