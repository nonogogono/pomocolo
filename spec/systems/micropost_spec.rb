require 'rails_helper'

RSpec.describe "Microposts", type: :system do
  include ApplicationHelper
  include ActionView::Helpers::DateHelper

  describe "show layout" do
    let!(:user) { create(:user) }
    let!(:taro) { create(:taro) }
    let!(:micropost_taro) { taro.microposts.create(content: "眠い...", created_at: 3.hours.ago) }
    let!(:comment_user) { user.comments.create(micropost_id: micropost_taro.id, content: "寝る前にちゃんとハミガキしてね") }
    let!(:comment_taro) { taro.comments.create(micropost_id: micropost_taro.id, content: "いいハミガキ粉あるかな？") }
    let!(:new_comment_text) { "シュミ○クトは知覚過敏にいいらしいよ。" }

    before do
      sign_in_as user
      visit micropost_path(micropost_taro)
    end

    it "コメントページにアクセスする" do
      expect(current_path).to eq micropost_path(micropost_taro)
      expect(title).to eq full_title(page_title: "コメント")

      within ".col-md-4" do
        expect(page).to have_selector '.user_info'
        expect(page).to have_selector '.stats'

        within ".comment_form" do
          expect(page).to have_selector "#comment-content-area"
        end
      end

      within ".col-md-8" do
        expect(page).to have_content micropost_taro.comments.count.to_s

        within "#micropost-#{micropost_taro.id}" do
          expect(page).to have_selector "img.gravatar"
          expect(page).to have_link micropost_taro.user.name, href: user_path(micropost_taro.user)
          expect(page).not_to have_selector ".task-info"
          expect(page).to have_content micropost_taro.content
          expect(page).to have_content "#{time_ago_in_words(micropost_taro.created_at)}前"
          expect(page).not_to have_link "削除", href: micropost_path(micropost_taro.id)
          expect(page).not_to have_content "コメント(#{micropost_taro.comments.count})"
        end

        within "#comment-#{comment_user.id}" do
          expect(page).to have_selector "img.gravatar"
          expect(page).to have_link comment_user.user.name, href: user_path(comment_user.user)
          expect(page).to have_content comment_user.content
          expect(page).to have_content "#{time_ago_in_words(comment_user.created_at)}前"
          expect(page).to have_link "削除", href: micropost_comment_path(micropost_taro.id, comment_user.id)
        end

        within "#comment-#{comment_taro.id}" do
          expect(page).to have_selector "img.gravatar"
          expect(page).to have_link comment_taro.user.name, href: user_path(comment_taro.user)
          expect(page).to have_content comment_taro.content
          expect(page).to have_content "#{time_ago_in_words(comment_taro.created_at)}前"
          expect(page).not_to have_link "削除", href: micropost_comment_path(micropost_taro.id, comment_taro.id)
        end
      end
    end

    it "フォームから comment を投稿する" do
      # フォームは空のまま
      click_button "コメント"
      expect(page).to have_content "コメント内容を入力してください"
      expect(current_path).to eq "#{micropost_path(micropost_taro)}/comments"

      # フォームに入力
      fill_in "Content", with: new_comment_text
      click_button "コメント"
      expect(page).to have_content "コメントされました！"
      expect(current_path).to eq micropost_path(micropost_taro)
      within ".comments" do
        expect(page).to have_content new_comment_text
      end
    end

    it "ダイアログを経由して comment を削除する", js: true do
      within "#comment-#{comment_user.id}" do
        page.accept_confirm "本当に削除しますか？" do
          click_link "削除"
        end
        expect(current_path).to eq micropost_path(micropost_taro)
      end
      expect(page).to have_content "コメントを削除しました！"
      expect(page).not_to have_content comment_user.content
    end
  end
end
