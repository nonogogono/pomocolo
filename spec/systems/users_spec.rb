require 'rails_helper'

RSpec.describe "Users", type: :system do
  include ApplicationHelper
  include ActionView::Helpers::DateHelper

  describe "show layout" do
    context "ゲストユーザーの場合" do
      let!(:guest) { create(:guest) }

      before do
        visit new_user_session_path
        click_on "ゲストログイン"
      end

      it "ユーザーページにアクセスする" do
        expect(current_path).to eq user_path(guest.id)
        expect(page).to have_content "ゲストユーザーとしてログインしました"

        within ".user_info" do
          expect(page).to have_content "※ゲストユーザーの変更・削除はできません"
          expect(page).not_to have_link "プロフィールを編集", href: edit_user_registration_path
        end
      end
    end

    context "ゲストユーザーでない場合" do
      let!(:user) { create(:user, profile: "海の王者になるために生まれました") }
      let!(:micropost_1) { user.microposts.create(content: "イカ漁", created_at: 10.minutes.ago, task: "漁", task_time: "30") }
      let!(:micropost_2) { user.microposts.create(content: "ホイ漁", created_at: 30.minutes.ago) }
      let!(:micropost_3) { user.microposts.create(content: "エビ漁", created_at: 45.minutes.ago) }
      let!(:micropost_4) { user.microposts.create(content: "カニ漁", created_at: 1.hour.ago) }
      let!(:micropost_5) { user.microposts.create(content: "クジラ漁", created_at: 5.hours.ago) }
      let!(:micropost_6) { user.microposts.create(content: "サンマ漁", created_at: 10.hours.ago) }
      let!(:micropost_7) { user.microposts.create(content: "タコ漁", created_at: 2.days.ago) }
      let!(:micropost_8) { user.microposts.create(content: "カジキ漁", created_at: 4.days.ago) }
      let!(:micropost_9) { user.microposts.create(content: "イワシ漁", created_at: 3.weeks.ago) }
      let!(:micropost_10) { user.microposts.create(content: "マグロ漁", created_at: 10.months.ago) }
      let!(:micropost_11) { user.microposts.create(content: "大漁", created_at: 20.years.ago) }
      let!(:micropost_12) { user.microposts.create(content: "蓮根", created_at: 21.years.ago) }
      let!(:micropost_13) { user.microposts.create(content: "大根", created_at: 22.years.ago) }
      let!(:micropost_14) { user.microposts.create(content: "人参", created_at: 23.years.ago) }
      let!(:micropost_15) { user.microposts.create(content: "玉ねぎ", created_at: 24.years.ago) }
      let!(:micropost_16) { user.microposts.create(content: "牛蒡", created_at: 25.years.ago) }
      let!(:micropost_17) { user.microposts.create(content: "白菜", created_at: 26.years.ago) }
      let!(:micropost_18) { user.microposts.create(content: "春菊", created_at: 27.years.ago) }
      let!(:micropost_19) { user.microposts.create(content: "ニラ", created_at: 28.years.ago) }
      let!(:micropost_20) { user.microposts.create(content: "鷹の爪", created_at: 29.years.ago) }
      let!(:micropost_21) { user.microposts.create(content: "青唐辛子", created_at: 30.years.ago) }

      before { sign_in_as user }

      it "ユーザーページにアクセスする" do
        expect(current_path).to eq user_path(user.id)
        expect(title).to eq full_title(page_title: user.name)
        expect(page).to have_content "ログインしました"

        within ".user_info" do
          expect(page).to have_selector "img.gravatar"
          expect(page).to have_content user.name
          expect(page).not_to have_content "※ゲストユーザーの変更・削除はできません"
          expect(page).to have_link "プロフィールを編集", href: edit_user_registration_path
          expect(page).to have_content user.profile
        end

        within ".stats" do
          expect(page).to have_link "フォロワー 0人", href: followers_user_path(user)
          expect(page).to have_link "フォロー中 0人", href: following_user_path(user)
        end

        within ".col-md-8" do
          expect(page).to have_content user.microposts.count.to_s

          within "#micropost-#{micropost_1.id}" do
            expect(page).to have_selector "img.gravatar"
            expect(page).to have_link micropost_1.user.name, href: user_path(micropost_1.user)
            expect(page).to have_selector ".task-info"
            within ".task-info" do
              expect(page).to have_content "##{micropost_1.task}"
              expect(page).to have_content "(#{micropost_1.task_time}分)"
            end
            expect(page).to have_content micropost_1.content
            expect(page).to have_content "#{time_ago_in_words(micropost_1.created_at)}前"
            expect(page).to have_link "削除", href: micropost_path(micropost_1.id)
            expect(page).to have_link "コメント(#{micropost_1.comments.count})", href: micropost_path(micropost_1.id)
          end

          within "#micropost-#{micropost_20.id}" do
            expect(page).to have_content micropost_20.content
            expect(page).not_to have_selector ".task-info"
          end

          expect(page).not_to have_content micropost_21.content
          expect(page).to have_selector "ul.pagination"
          click_link "2"
          expect(page).not_to have_content micropost_20.content
          expect(page).to have_content micropost_21.content
        end
      end

      it "ダイアログを経由して micropost を削除する", js: true do
        # 削除をキャンセル
        within "#micropost-#{micropost_1.id}" do
          page.dismiss_confirm "本当に削除しますか？" do
            click_link "削除"
          end
          expect(current_path).to eq user_path(user.id)
        end
        expect(page).to have_content micropost_1.content

        # 削除を実行
        within "#micropost-#{micropost_1.id}" do
          page.accept_confirm "本当に削除しますか？" do
            click_link "削除"
          end
          expect(current_path).to eq user_path(user.id)
        end
        expect(page).not_to have_content micropost_1.content
      end
    end
  end
end
