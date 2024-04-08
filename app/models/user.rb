# frozen_string_literal: true

# This class represent the Users sign up for and visit the frontend application
# and whose records are persisted in the database
class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :visits
  belongs_to :registration_ip_info, class_name: 'IpInfo'

  accepts_nested_attributes_for :registration_ip_info

  validates :username, presence: true, uniqueness: { case_sensitive: false }

  before_validation :find_or_create_ip_info

  private

  def find_or_create_ip_info
    self.registration_ip_info = IpInfo.find_or_create_by(
      address: registration_ip_info&.address
    )
  end
end
