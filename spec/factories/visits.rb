FactoryBot.define do
  factory :visit do
    association :page
    association :user
    association :ip_info
    visited_at { Time.now }
  end
end
