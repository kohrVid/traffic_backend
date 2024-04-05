FactoryBot.define do
  factory :user do
    username { 'cleo' }
    email { 'cleo@kohrvid.com' }
    password { 'Password1234!' }
    password_confirmation { 'Password1234!' }
    registration_ip_info { create(:ip_info, :vpn) }
  end
end
