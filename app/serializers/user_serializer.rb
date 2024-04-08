# frozen_string_literal: true

# Serialiser for User records.
class UserSerializer
  include ActiveModel::Serialization

  def initialize(user = {})
    @user = user
  end

  def attributes
    {
      id: nil,
      username: nil,
      email: nil,
      is_admin: nil,
      registration_ip_info: nil,
      created_at: nil,
      updated_at: nil
    }
  end

  private

  def id
    @user[:id]
  end

  def username
    @user[:username]
  end

  def email
    @user[:email]
  end

  def is_admin
    @user[:is_admin]
  end

  def registration_ip_info
    {
      address: @user&.registration_ip_info[:address],
      latitude: @user&.registration_ip_info[:latitude],
      longitude: @user&.registration_ip_info[:longitude]
    }
  end

  def latitude
    @user.latitude.to_f
  end

  def longitude
    @user.longitude.to_f
  end

  def created_at
    @user[:created_at]
  end

  def updated_at
    @user[:updated_at]
  end
end
