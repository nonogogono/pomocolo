require 'rails_helper'

RSpec.describe "UsersRegistrations", type: :system do
  include ApplicationHelper

  describe "edit layout" do
    let!(:user) { create(:user, profile: "マン・オブ・スティールはマーベル作品？") }

    before do
      sign_in_as user
      visit edit_user_registration_path
    end

    it "ユーザープロフィールを更新する" do
      expect(title).to eq full_title(page_title: user.name)

      # autocomplete
      all(".field")[0] do
        expect(page).to have_content user.name
      end
      all(".field")[1] do
        expect(page).to have_content user.profile
      end
      all(".field")[2] do
        expect(page).to have_content user.email
      end
      all(".field")[3] do
        expect(page).not_to have_content user.password
      end

      # 更新に失敗
      fill_in "ユーザー名", with: ""
      fill_in "profile-area", with: ""
      fill_in "メールアドレス", with: ""
      fill_in "パスワード", with: ""
      click_button "更新"
      expect(current_path).to eq "/users"
      expect(page).to have_content "3 件のエラーが発生したため ユーザー は保存されませんでした"
      expect(page).to have_content "ユーザー名が入力されていません"
      expect(page).to have_content "メールアドレスが入力されていません"
      expect(page).to have_content "パスワードを入力してください"
      fill_in "ユーザー名", with: "superman"
      fill_in "profile-area", with: "マン・オブ・スティールはDCコミックスです！？"
      fill_in "メールアドレス", with: "man-of-steel@dc-commics.com"
      fill_in "パスワード", with: "ironman"
      click_button "更新"
      expect(current_path).to eq "/users"
      expect(page).to have_content "パスワードは不正な値です"

      # 更新に成功
      fill_in "パスワード", with: "password"
      click_button "更新"
      expect(current_path).to eq user_path(user)
      expect(page).to have_content "アカウント情報を変更しました"
    end

    it "ユーザーページへ戻る" do
      click_link "戻る"
      expect(current_path).to eq user_path(user)
    end

    it "ユーザーアカウントを削除する", js: true do
      # 削除をキャンセル
      page.dismiss_confirm "本当に削除しますか？" do
        click_link "アカウント削除"
      end
      expect(current_path).to eq edit_user_registration_path

      # 削除を実行
      page.accept_confirm "本当に削除しますか？" do
        click_link "アカウント削除"
      end
      expect(current_path).to eq new_user_session_path
      expect(page).to have_content "アカウント登録もしくはログインしてください"
    end
  end
end
