FactoryBot.define do
  factory :task do
    name { "プログラミング" }
    created_at { Time.zone.now }
    user { create(:user) }
  end
end
