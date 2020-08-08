FactoryBot.define do
  factory :user do
    name { "tester" }
    sequence(:email) { |n| "tester-#{n}@example.org" }
    password { "password" }
  end

  factory :taro, class: "User" do
    name { "taro" }
    sequence(:email) { |n| "okamoto-#{n}@example.org" }
    password { "password" }
  end
end
