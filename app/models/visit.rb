class Visit < ApplicationRecord
  belongs_to :page
  belongs_to :user
  belongs_to :ip_info

  scope :with_info, -> {
    includes(:ip_info)
  }
end
