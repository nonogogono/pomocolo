require 'rails_helper'

RSpec.describe "UsersSessions", type: :system do
  include ApplicationHelper

  describe "do sign_in" do
    let!(:user) { create(:user) }
    let!(:unconfirmed_user) { create(:unconfirmed_user) }

    context "ユーザー認証が完了済の場合" do
      before { sign_in_as user }

      it "ログインができること" do
        expect(current_path).to eq user_path(user)
        expect(page).to have_content "ログインしました。"
      end
    end

    context "ユーザー認証が未完了の場合" do
      before { sign_in_as unconfirmed_user }

      it "ユーザー認証を求められること" do
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content "メールアドレスの本人確認が必要です。"
      end
    end
  end
end
