class Visit < ApplicationRecord
  belongs_to :page
  belongs_to :user, optional: true
  belongs_to :ip_info

  accepts_nested_attributes_for :ip_info

  before_validation :find_or_create_ip_info

  delegate :address, :latitude, :longitude, to: :ip_info

  scope :for_page, -> (page_id) { where(page_id: page_id) }

  scope :visited_between, -> (start_time, end_time) {
    where(visited_at: [start_time...end_time])
  }

  private

  def find_or_create_ip_info
    self.ip_info = IpInfo.find_or_create_by(address: ip_info&.address)
  end
end
