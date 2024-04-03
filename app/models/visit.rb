class Visit < ApplicationRecord
  belongs_to :page
  belongs_to :user, optional: true
  belongs_to :ip_info

  accepts_nested_attributes_for :ip_info

  before_validation :find_or_create_ip_info

  private

  def find_or_create_ip_info
    self.ip_info = IpInfo.find_or_create_by(address: ip_info.address)
  end
end
