FactoryBot.define do
  factory :micropost_2hours_ago, class: "Micropost" do
    content { "ランニング" }
    created_at { 2.hours.ago }
    user { create(:user) }
  end

  factory :micropost_now, class: "Micropost" do
    content { "読書" }
    created_at { Time.zone.now }
    user { create(:user) }
  end

  factory :micropost_taro, class: "Micropost" do
    content { "芸術は爆発だ" }
    created_at { Time.zone.now }
    user { create(:taro) }
  end
end
