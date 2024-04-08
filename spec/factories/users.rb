# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { 'cleo' }
    email { 'cleo@kohrvid.com' }
    password { 'Password1234!' }
    password_confirmation { 'Password1234!' }
    registration_ip_info { create(:ip_info, :vpn) }

    trait :random_name do
      sequence(:username, 'a') { |n| "user#{n}" }
      sequence(:email, 'a') { |n| "user#{n}@kohrvid.com" }

      registration_ip_info do
        IpInfo.find_or_create_by(attributes_for(:ip_info, :vpn))
      end
    end
  end
end
