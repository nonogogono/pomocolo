require 'rails_helper'

RSpec.describe "Users", type: :system do
  include ApplicationHelper
  include ActionView::Helpers::DateHelper

  describe "show layout" do
    let!(:user) { create(:user, profile: "海の王者になるために生まれました") }
    let!(:micropost) { user.microposts.create(content: "イカ漁", created_at: 10.minutes.ago) }
    let!(:micropost_1) { user.microposts.create(content: "ホイ漁", created_at: 30.minutes.ago) }
    let!(:micropost_2) { user.microposts.create(content: "エビ漁", created_at: 45.minutes.ago) }
    let!(:micropost_3) { user.microposts.create(content: "カニ漁", created_at: 1.hour.ago) }
    let!(:micropost_4) { user.microposts.create(content: "クジラ漁", created_at: 5.hours.ago) }
    let!(:micropost_5) { user.microposts.create(content: "サンマ漁", created_at: 10.hours.ago) }
    let!(:micropost_6) { user.microposts.create(content: "タコ漁", created_at: 2.days.ago) }
    let!(:micropost_7) { user.microposts.create(content: "カジキ漁", created_at: 4.days.ago) }
    let!(:micropost_8) { user.microposts.create(content: "イワシ漁", created_at: 3.weeks.ago) }
    let!(:micropost_9) { user.microposts.create(content: "マグロ漁", created_at: 10.months.ago) }
    let!(:micropost_10) { user.microposts.create(content: "大漁", created_at: 20.years.ago) }

    before { sign_in_as user }

    it "ユーザーページにアクセスする" do
      expect(current_path).to eq user_path(user.id)
      expect(title).to eq full_title(page_title: user.name)

      within ".user_info" do
        expect(page).to have_selector "img.gravatar"
        expect(page).to have_content user.name
        expect(page).to have_link "プロフィールを編集", href: edit_user_registration_path
        expect(page).to have_content user.profile
      end

      within ".col-md-8" do
        expect(page).to have_content user.microposts.count.to_s
        expect(page).to have_selector "img.gravatar"
        expect(page).to have_link micropost.user.name, href: user_path(micropost.user)
        expect(page).to have_content micropost.content
        expect(page).to have_content "#{time_ago_in_words(micropost.created_at)}前"
        expect(page).to have_link "削除", href: micropost_path(micropost.id)
        expect(page).to have_selector "ul.pagination"
        click_link "2"
        expect(page).not_to have_content micropost_9.content
        expect(page).to have_content micropost_10.content
      end
    end

    it "ダイアログを経由して micropost を削除する", js: true do
      # 削除をキャンセル
      within "#micropost-#{micropost.id}" do
        page.dismiss_confirm "本当に削除しますか？" do
          click_link "削除"
        end
        expect(current_path).to eq user_path(user.id)
      end
      expect(page).to have_content micropost.content

      # 削除を実行
      within "#micropost-#{micropost.id}" do
        page.accept_confirm "本当に削除しますか？" do
          click_link "削除"
        end
        expect(current_path).to eq user_path(user.id)
      end
      expect(page).not_to have_content micropost.content
    end
  end
end
