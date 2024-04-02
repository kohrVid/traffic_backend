class Visit < ApplicationRecord
  belongs_to :page
  belongs_to :user
  belongs_to :ip_info
end
