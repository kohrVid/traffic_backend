class User < ApplicationRecord
  belongs_to :registration_ip_info, class_name: 'IpInfo'

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
