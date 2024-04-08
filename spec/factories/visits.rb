# frozen_string_literal: true

FactoryBot.define do
  factory :visit do
    association :page
    visited_at { Time.now }

    trait :with_ip_info do
      association :ip_info
    end
  end
end
