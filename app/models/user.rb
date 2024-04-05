class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :registration_ip_info, class_name: 'IpInfo'

  validates :username, presence: true, uniqueness: { case_sensitive: false }
end
