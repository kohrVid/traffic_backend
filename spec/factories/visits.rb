FactoryBot.define do
  factory :visit do
    association :page
    association :user
    association :ip_info
  end
end
