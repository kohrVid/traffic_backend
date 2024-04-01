FactoryBot.define do
  factory :user do
    username { 'cleo' }
    registration_ip_info { create(:ip_info, :vpn) }
  end
end
