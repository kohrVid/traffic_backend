# frozen_string_literal: true

# Serialiser for Visit records. The Visit model represents individual
# visits to pages with tracking enabled on the frontend
class VisitSerializer
  include ActiveModel::Serialization

  def initialize(visit = {})
    @visit = visit
  end

  def attributes
    {
      id: nil,
      page_id: nil,
      page_name: nil,
      page_url: nil,
      user_id: nil,
      visited_at: nil,
      ip_address: nil,
      latitude: nil,
      longitude: nil
    }
  end

  private

  def id
    @visit[:id]
  end

  def page_id
    @visit[:page_id]
  end

  def page_name
    @visit.page[:name]
  end

  def page_url
    @visit.page[:url]
  end

  def user_id
    @visit[:user_id]
  end

  def visited_at
    @visit[:visited_at]
  end

  def ip_address
    @visit.ip_info[:address]
  end

  def latitude
    @visit.latitude.to_f
  end

  def longitude
    @visit.longitude.to_f
  end
end
