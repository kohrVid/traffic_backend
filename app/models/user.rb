class User < ApplicationRecord
  belongs_to :registration_ip_info, class_name: 'IpInfo'
end
