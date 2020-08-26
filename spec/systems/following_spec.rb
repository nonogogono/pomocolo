require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  include ApplicationHelper

  describe "users/show_follow layout" do
    let!(:user) { create(:user) }
    let!(:taro) { create(:taro) }
    let!(:cameron) { create(:cameron) }
    let!(:hikonyan) { create(:user, name: "hikonyan") }
    let!(:funassyi) { create(:user, name: "funassyi") }
    let!(:kumamon) { create(:user, name: "kumamon") }

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

    it "フォロー中リストへアクセスする" do
      visit following_user_path(user)
      expect(title).to eq full_title(page_title: "フォロー中")
      expect(user.following.empty?).to eq false

      within ".users" do
        expect(page).to have_selector "li", count: user.following.count
        user.followers.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
        end
      end
    end

    it "フォロワーリストへアクセスする" do
      visit followers_user_path(user)
      expect(title).to eq full_title(page_title: "フォロワー")
      expect(user.followers.empty?).to eq false

      within ".users" do
        expect(page).to have_selector "li", count: user.followers.count
        user.followers.each do |u|
          expect(page).to have_link u.name, href: user_path(u)
        end
      end
    end
  end

  describe "#follow_form" do
    let!(:user) { create(:user) }
    let!(:taro) { create(:taro) }

    before do
      sign_in_as user
      visit user_path(taro)
    end

    it "フォローとアンフォローのボタンをクリックする", xhr: true do
      within "#follow_form" do
        expect(user.following.count).to eq 0
        click_button "フォローする"
        expect(user.following.count).to eq 1
        click_button "フォロー中"
        expect(user.following.count).to eq 0
      end
    end
  end
end
