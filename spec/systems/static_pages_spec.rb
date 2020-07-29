require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  describe "ヘッダー" do
    before do
      visit root_path
    end

    it "トップページへのリンクが２つあること" do
      within "header" do
        expect(page).to have_link nil, href: root_path, count: 2
      end
    end

    context "ログインしている場合" do
      let!(:user) { create(:user) }

      before do
        sign_in_as user
      end

      it "ログインが成功した flash が表示されること" do
        expect(page).to have_content "Signed in successfully."
      end

      it "ユーザーページのリンクがあること" do
        within "header" do
          expect(page).to have_link "あなた", href: user_path(user)
        end
      end

      it "ログアウトができること" do
        within "header" do
          expect(page).to have_link "ログアウト", href: destroy_user_session_path
          click_link "ログアウト"
        end
        expect(page).to have_content "You need to sign in or sign up before continuing."
      end
    end

    context "ログインしていない場合" do
      it "ユーザー登録ページのリンクがあること" do
        within "header" do
          expect(page).to have_link "ユーザー登録", href: new_user_registration_path
        end
      end

      it "ログインページのリンクがあること" do
        within "header" do
          expect(page).to have_link "ログイン", href: new_user_session_path
        end
      end
    end
  end
end
