FactoryBot.define do
  factory :user do
    name { "tester" }
    sequence(:email) { |n| "tester-#{n}@example.org" }
    password { "password" }
    confirmed_at { Time.now }
  end

  factory :unconfirmed_user, class: "User" do
    name { "poor-man" }
    sequence(:email) { |n| "poor-#{n}@example.org" }
    password { "password" }
  end

  factory :taro, class: "User" do
    name { "taro" }
    sequence(:email) { |n| "okamoto-#{n}@example.org" }
    password { "password" }
    confirmed_at { Time.now }
  end

  factory :cameron, class: "User" do
    name { "diaz" }
    sequence(:email) { |n| "mask-#{n}@example.org" }
    password { "password" }
    confirmed_at { Time.now }
  end

  factory :guest, class: "User" do
    name { "guest" }
    sequence(:email) { "guest@example.com" }
    password { SecureRandom.urlsafe_base64 }
    confirmed_at { Time.now }
  end
end
