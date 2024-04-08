# frozen_string_literal: true

FactoryBot.define do
  factory :page do
    name { 'about' }
    url { 'http://localhost:1234/about' }
  end
end
