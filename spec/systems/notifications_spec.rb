require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  include ApplicationHelper

  describe "index layout" do
    context "ログインしている場合" do
      let!(:user) { create(:user, name: "User") }
      let!(:taro) { create(:user, name: "Taro") }
      let!(:john) { create(:user, name: "John") }
      let!(:micropost_user_for_like) { create(:micropost_now, user_id: user.id, content: "風が完治しました") }
      let!(:micropost_user_for_comment) { create(:micropost_now, user_id: user.id, content: "今週の天気どうかな？") }
      let!(:micropost_john) { create(:micropost_now, user_id: john.id, content: "天ぷら揚げた") }
      let!(:comment_user) { user.comments.create(content: "エビおいしそう", micropost_id: micropost_john.id) }

      context "通知がない場合" do
        before do
          sign_in_as user
          visit notifications_path
        end

        it "通知ページにアクセスする" do
          expect(current_path).to eq notifications_path
          expect(title).to eq full_title(page_title: "通知")
          expect(page).to have_content "通知はありません"
        end
      end

      context "通知がある場合" do
        # 別ユーザー(taro) で user の通知内容を作る
        before do
          # user をフォローする
          taro.follow(user)
          user.notify_follow(taro)
          # user の投稿にいいねする
          micropost_user_for_like.like(taro)
          micropost_user_for_like.notify_like(taro)
          # user の投稿にコメントする
          comment_taro = taro.comments.create(content: "明日は雨が降るかも", micropost_id: micropost_user_for_comment.id)
          micropost_user_for_comment.notify_comment(taro, comment_taro.id)
          # user がコメントした john の投稿にコメントする
          comment_taro_after_user = taro.comments.create(content: "大葉も捨てがたい", micropost_id: micropost_john.id)
          micropost_john.notify_comment(taro, comment_taro_after_user.id)
        end

        it "通知ページにアクセスする" do
          sign_in_as user
          # 通知マークが出る
          expect(page).to have_selector ".fa-stack"
          visit notifications_path
          # 通知マークが消える
          expect(page).not_to have_selector ".fa-stack"
          # それぞれの内容
          expect(page).to have_content "#{taro.name} さんが あなた をフォローしました"
          expect(page).to have_content "#{taro.name} さんが あなたの投稿 にいいねしました"
          expect(page).to have_content "#{micropost_user_for_like.content}"
          expect(page).to have_content "#{taro.name} さんが あなたの投稿 にコメントしました"
          expect(page).to have_content "#{micropost_user_for_comment.content} > #{micropost_user_for_comment.comments.last.content}"
          expect(page).to have_content "#{taro.name} さんが #{john.name} さんの投稿 にコメントしました"
          expect(page).to have_content "#{micropost_john.content} > #{micropost_john.comments.last.content}"
        end
      end
    end

    context "ログインしていない場合" do
      before { visit notifications_path }

      it "通知ページにアクセスすると、ログインページにリダイレクトされる" do
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
