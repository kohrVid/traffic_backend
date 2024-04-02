require 'rails_helper'

RSpec.describe "Visits", type: :request do
  let(:page) { create(:page) }
  let(:user) { create(:user) }
  let(:ip_info) { create(:ip_info) }
  let(:visited_at) { Time.zone.now }
  let(:time_format) { '%Y.%m.%D %H:%M:%S' }

  describe 'POST /visits' do
    scenario 'with unsuccessful params' do
      post visits_path,
        params: {
          visit: {
            page_id: page.id,
            user_id: user.id,
            visited_at: visited_at,
            ip_info_attributes: {
              address: nil
            }
          }
        }

      expect(response).to have_http_status(400)

      expect(
        JSON.parse(response.body)
      ).to include(
        "errors" => ["an error has prevented the visit from being saved"]
      )
    end

    scenario 'the IP address already exists in the database' do
      post visits_path,
        params: {
          visit: {
            page_id: page.id,
            user_id: user.id,
            visited_at: visited_at,
            ip_info_attributes: {
              address: ip_info.address
            }
          }
        }

      expect(response).to have_http_status(201)

      expect(
        JSON.parse(response.body)
      ).to include("data" => Visit.last.to_json)

      expect(Visit.last.visited_at.strftime(time_format)).to eq(
        visited_at.strftime(time_format)
      )

      expect(Visit.last.page).to eq(page)
      expect(Visit.last.user).to eq(user)
      expect(Visit.last.ip_info).to eq(ip_info)
    end

    scenario 'the IP address does not already exist in the database' do
      post visits_path,
        params: {
          visit: {
            page_id: page.id,
            user_id: user.id,
            visited_at: visited_at,
            ip_info_attributes: {
              address: '56.235.4.155'
            }
          }
        }

      expect(response).to have_http_status(201)

      expect(
        JSON.parse(response.body)
      ).to include("data" => Visit.last.to_json)

      expect(Visit.last.visited_at.strftime(time_format)).to eq(
        visited_at.strftime(time_format)
      )

      expect(Visit.last.page).to eq(page)
      expect(Visit.last.user).to eq(user)
      expect(Visit.last.ip_info).to eq(IpInfo.last)
      expect(IpInfo.last.address).to eq('56.235.4.155')
    end
  end
end
