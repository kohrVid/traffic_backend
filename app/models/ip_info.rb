class IpInfo < ApplicationRecord
  has_many :registered_users, class_name: 'User'
  has_many :visits

  validates :address, presence: true
end
