require 'rails_helper'

RSpec.describe "Visits", type: :request do
  let(:page) { create(:page, name: 'contact') }
  let(:user) { create(:user) }
  let(:ip_info) { create(:ip_info) }
  let(:visited_at) { Time.zone.now }
  let(:time_format) { '%Y.%m.%d %H:%M:%S' }
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  describe 'GET /index' do
    let(:time_format) { '%Y-%m-%dT%H:%M:%S.%LZ' }

    let(:visit1) do
      create(
        :visit,
        user: user,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 15)
      )
    end

    let(:visit2) do
      create(
        :visit,
        user: user,
        ip_info: ip_info,
        page: page,
        visited_at: Time.local(2024, 4, 4, 2, 50)
      )
    end

    let(:visit3) do
      create(
        :visit,
        user: user,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 14, 49)
      )
    end

    before do
      visit1
      visit2
    end

    scenario 'without a query string' do
      get visits_path

      expect(response).to have_http_status(200)
      expect(
        JSON.parse(response.body)
      ).to include("data" => [
        {
          "page_id" => visit1.page_id,
          "user_id" => visit1.user_id,
          "visited_at" => visit1.visited_at.strftime(time_format),
          "ip_address" => visit1.address,
          "latitude" => visit1.latitude.to_f,
          "longitude" => visit1.longitude.to_f
        },
        {
          "page_id" => visit2.page_id,
          "user_id" => visit2.user_id,
          "visited_at" => visit2.visited_at.strftime(time_format),
          "ip_address" => visit2.address,
          "latitude" => visit2.latitude.to_f,
          "longitude" => visit2.longitude.to_f
        }
      ])
    end

    scenario 'with a query string' do
      get visits_path,
        params: {
          page_id: page.id,
          from: Time.local(2024, 4, 3, 14, 50),
          to: Time.local(2024, 4, 5, 14, 50)
        }

      expect(response).to have_http_status(200)
      expect(
        JSON.parse(response.body)
      ).to include("data" => [
        {
          "page_id" => visit2.page_id,
          "user_id" => visit2.user_id,
          "visited_at" => visit2.visited_at.strftime(time_format),
          "ip_address" => visit2.address,
          "latitude" => visit2.latitude.to_f,
          "longitude" => visit2.longitude.to_f
        }
      ])
    end
  end

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
