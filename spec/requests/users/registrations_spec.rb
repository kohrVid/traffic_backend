require 'rails_helper'

RSpec.describe "Users::Registrations", type: :request do
  describe 'POST /users' do
    let!(:ip_info) { create(:ip_info) }
    let(:user) { build(:user) }

    scenario 'with unsuccessful params' do
      post user_registration_path,
        params: {
          format: 'json',
            user: {
              email: '',
              username: user.username,
              password: user.password,
              password_confirmation: user.password_confirmation,
              registration_ip_info_attributes: {
                address: ip_info.address
              }
          }
        }

      expect(response).to have_http_status(422)

      expect(
        JSON.parse(response.body)
      ).to include(
        "errors" => { "email" => ["can't be blank"] }
      )
    end

    scenario 'with successful params' do
      post user_registration_path,
        params: {
          format: 'json',
            user: {
              email: user.email,
              username: user.username,
              password: user.password,
              password_confirmation: user.password_confirmation,
              registration_ip_info_attributes: {
                address: ip_info.address
              }
          }
        }

      expect(response).to have_http_status(201)

      expect(
        JSON.parse(response.body)['data']
      ).to eq(User.last.as_json)

      expect(User.last.username).to eq(user.username)
      expect(User.last.registration_ip_info).to eq(ip_info)
    end
  end
end
