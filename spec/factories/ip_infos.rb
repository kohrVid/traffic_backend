FactoryBot.define do
  factory :ip_info do
    address { '213.152.176.135' }
    latitude { 52.3740 }
    longitude { 4.8897 }

    trait :vpn do
      address { '213.152.176.136' }
      is_vpn { true }
    end
  end
end
