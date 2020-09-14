require 'rails_helper'

RSpec.describe "StaticPages", type: :system do
  include ApplicationHelper

  describe "week layout" do
    before do
      visit week_path
    end

    context "ログインしている場合" do
      let!(:user) { create(:user) }
      let!(:task_1) { user.tasks.create(name: "ジョギング") }
      let!(:task_2) { user.tasks.create(name: "筋トレ") }
      let!(:task_3) { user.tasks.create(name: "買い物") }
      let!(:task_4) { user.tasks.create(name: "料理") }
      let!(:task_5) { user.tasks.create(name: "居合") }
      let!(:task_6) { user.tasks.create(name: "草むしり") }
      let!(:task_7) { user.tasks.create(name: "水泳") }
      let!(:micropost_last_week) { user.microposts.create(content: "10km", created_at: Time.zone.now.prev_week, task: task_1, task_time: 60) }
      let!(:micropost_task_2_monday) { user.microposts.create(content: "懸垂", created_at: Time.zone.now.beginning_of_week.days_since(0), task: task_2, task_time: 50) }
      let!(:micropost_task_6_monday) { user.microposts.create(content: "腰がいわしそう", created_at: (Time.zone.now.beginning_of_week.days_since(0) + 6.hours), task: task_6, task_time: 50) }
      let!(:micropost_task_7_monday_1) { user.microposts.create(content: "クロール", created_at: (Time.zone.now.beginning_of_week.days_since(0) + 9.hours), task: task_7, task_time: 30) }
      let!(:micropost_task_7_monday_2) { user.microposts.create(content: "平泳ぎ", created_at: (Time.zone.now.beginning_of_week.days_since(0) + 10.hours), task: task_7, task_time: 60) }
      let!(:micropost_task_4_tuesday_1) { user.microposts.create(content: "ナスのお浸し", created_at: Time.zone.now.beginning_of_week.days_since(1), task: task_4, task_time: 20) }
      let!(:micropost_task_4_tuesday_2) { user.microposts.create(content: "無水カレー", created_at: (Time.zone.now.beginning_of_week.days_since(1) + 1.hours), task: task_4, task_time: 30) }
      let!(:micropost_task_4_tuesday_3) { user.microposts.create(content: "かぼちゃぷりん", created_at: (Time.zone.now.beginning_of_week.days_since(1) + 2.hours), task: task_4, task_time: 5) }
      let!(:micropost_task_2_friday) { user.microposts.create(content: "バーピー", created_at: (Time.zone.now.beginning_of_week.days_since(4) + 12.hours), task: task_2, task_time: 15) }
      let!(:micropost_task_5_friday) { user.microposts.create(content: "会得したり", created_at: (Time.zone.now.beginning_of_week.days_since(4) + 14.hours), task: task_5, task_time: 60) }
      let!(:total_time_monday) { micropost_task_2_monday.task_time + micropost_task_6_monday.task_time + micropost_task_7_monday_1.task_time + micropost_task_7_monday_2.task_time }
      let!(:total_time_tuesday) { micropost_task_4_tuesday_1.task_time + micropost_task_4_tuesday_2.task_time + micropost_task_4_tuesday_3.task_time }
      let!(:total_time_friday) { micropost_task_2_friday.task_time + micropost_task_5_friday.task_time }

      before do
        sign_in_as user
        visit week_path
      end

      it "週グラフページにアクセスする" do
        expect(current_path).to eq week_path
        expect(title).to eq full_title(page_title: "グラフ")
        expect(page).to have_link "今日", href: timer_path
        expect(page).to have_link "今月", href: month_path

        within 'h1' do
          expect(page).to have_content "#{Time.zone.now.beginning_of_week.year}/#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.day} ~ #{Time.zone.now.end_of_week.year}/#{Time.zone.now.end_of_week.month}/#{Time.zone.now.end_of_week.day}"
        end

        within ".legend" do
          expect(page).to have_selector 'li', count: 5
          expect(page).to have_selector 'li', text: task_2
          expect(page).to have_selector 'li', text: task_4
          expect(page).to have_selector 'li', text: task_5
          expect(page).to have_selector 'li', text: task_6
          expect(page).to have_selector 'li', text: task_7
        end

        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(0).day} (#{total_time_monday})"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(1).day} (#{total_time_tuesday})"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(2).day} (0)"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(3).day} (0)"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(4).day} (#{total_time_friday})"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(5).day} (0)"
        expect(page).to have_content "#{Time.zone.now.beginning_of_week.month}/#{Time.zone.now.beginning_of_week.days_since(6).day} (0)"

        within "#chart-0" do
          expect(page).to have_selector '.value', count: 3
          expect(page).to have_selector '.value', text: micropost_task_2_monday.task_time
          expect(page).to have_selector '.value', text: micropost_task_6_monday.task_time
          expect(page).to have_selector '.value', text: (micropost_task_7_monday_1.task_time + micropost_task_7_monday_2.task_time)
        end

        within "#chart-1" do
          expect(page).to have_selector '.value', count: 1
          expect(page).to have_selector '.value', text: total_time_tuesday
        end

        within "#chart-2" do
          expect(page).not_to have_selector '.value'
        end

        within "#chart-3" do
          expect(page).not_to have_selector '.value'
        end

        within "#chart-4" do
          expect(page).to have_selector '.value', count: 2
          expect(page).to have_selector '.value', text: micropost_task_2_friday.task_time
          expect(page).to have_selector '.value', text: micropost_task_5_friday.task_time
        end

        within "#chart-5" do
          expect(page).not_to have_selector '.value'
        end

        within "#chart-6" do
          expect(page).not_to have_selector '.value'
        end
      end
    end

    context "ログインしていない場合" do
      it "トップページにアクセスすると、ログインページにリダイレクトされる" do
        expect(current_path).to eq new_user_session_path
      end
    end
  end
end
