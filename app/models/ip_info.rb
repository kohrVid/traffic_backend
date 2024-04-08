# frozen_string_literal: true

# This model is used persist geolocation data about a given IP address
class IpInfo < ApplicationRecord
  has_many :registered_users, class_name: 'User'
  has_many :visits

  after_create :get_location_data

  validates :address, presence: true, uniqueness: { case_sensitive: false }

  def loopback?
    ['127.0.0.1', '::1'].include? address
  end

  private

  def get_location_data
    return if loopback?
    return if latitude && longitude

    ip_location = IpLocation.new(ip_address: address)
    lat, lon = ip_location.coordinates
    is_vpn = ip_location.vpn?

    update(
      latitude: lat,
      longitude: lon,
      is_vpn:
    )
  end
end
