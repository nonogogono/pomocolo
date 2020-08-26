require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  include ApplicationHelper

  describe "home layout" do
    before do
      visit root_path
    end

    context "ログインしている場合" do
      let!(:user) { create(:user) }
      let!(:taro) { create(:taro) }
      let!(:cameron) { create(:cameron) }
      let!(:hikonyan) { create(:user, name: "hikonyan") }
      let!(:funassyi) { create(:user, name: "funassyi") }
      let!(:kumamon) { create(:user, name: "kumamon") }
      let!(:long_text) { "l" * 201 }
      let!(:good_text) { "今日はいい天気じゃのう。" }
      let!(:taro_micropost1) { taro.microposts.create!(content: "芸術は爆発だ") }
      let!(:taro_micropost2) { taro.microposts.create!(content: "自分の中に毒を持て") }
      let!(:cameron_micropost1) { taro.microposts.create!(content: "メリーに首ったけ") }
      let!(:cameron_micropost2) { taro.microposts.create!(content: "バッド・ティーチャー") }

      before do
        user.follow(taro)
        user.follow(cameron)
        user.follow(hikonyan)
        user.follow(funassyi)
        user.follow(kumamon)
        taro.follow(user)
        funassyi.follow(user)
        kumamon.follow(user)
        sign_in_as user
      end

      it "トップページにアクセスする" do
        expect(page).to have_content "ログインしました"
        visit root_path
        expect(current_path).to eq root_path
        expect(title).to eq full_title

        within "header" do
          expect(page).to have_link nil, href: root_path, count: 2
          expect(page).to have_link "タイマー", href: timer_path
          expect(page).to have_link "あなた", href: user_path(user)
          expect(page).to have_link "ログアウト", href: destroy_user_session_path
        end

        within ".stats" do
          expect(page).to have_link "フォロワー 3人", href: followers_user_path(user)
          expect(page).to have_link "フォロー中 5人", href: following_user_path(user)
        end

        within ".microposts" do
          user.feed.page.each do |micropost|
            expect(page).to have_content micropost.content
          end
        end
      end

      it "micropost を投稿する" do
        visit root_path

        # フォームは空のまま
        click_button "投稿"
        expect(page).to have_content "1つエラーがあります"
        expect(page).to have_content "Contentを入力してください"
        expect(current_path).to eq "/microposts"

        # フォームに201文字を入力
        fill_in "何かメモする？", with: long_text
        click_button "投稿"
        expect(page).to have_content "1つエラーがあります"
        expect(page).to have_content "Contentは200文字以内で入力してください"
        expect(current_path).to eq "/microposts"
        within ".col-md-8" do
          expect(page).not_to have_content long_text
        end

        # フォームに200字以内で入力
        fill_in "何かメモする？", with: good_text
        click_button "投稿"
        expect(page).to have_content "投稿されました！"
        expect(current_path).to eq root_path
        within ".microposts" do
          expect(page).to have_content good_text
        end
      end

      it "ログアウトする" do
        click_link "ログアウト"
        expect(current_path).to eq new_user_session_path
        expect(page).to have_content "アカウント登録もしくはログインしてください"
      end
    end

    context "ログインしていない場合" do
      it "トップページにアクセスすると、ログインページにリダイレクトされる" do
        expect(current_path).to eq new_user_session_path
        expect(title).to eq full_title(page_title: "ログイン")
        expect(page).to have_content "アカウント登録もしくはログインしてください"

        within "header" do
          expect(page).to have_link nil, href: root_path, count: 2
          expect(page).to have_link "タイマー", href: timer_path
          expect(page).to have_link "ユーザー登録", href: new_user_registration_path
          expect(page).to have_link "ログイン", href: new_user_session_path
        end
      end
    end
  end
end
