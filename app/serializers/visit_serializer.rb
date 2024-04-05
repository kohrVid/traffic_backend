class VisitSerializer
  include ActiveModel::Serialization

  def initialize(visit = {})
    @visit = visit
  end

  def attributes
    {
      page_id: nil,
      user_id: nil,
      visited_at: nil,
      ip_address: nil,
      latitude: nil,
      longitude: nil
    }
  end

  private

  def page_id
    @visit[:page_id]
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
