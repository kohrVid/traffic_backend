# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users', type: :request do
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  path '/users' do
    get 'list users' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      user_attributes = FactoryBot.attributes_for(
        :user,
        registration_ip_info: IpInfo.find_or_create_by(
          FactoryBot.attributes_for(:ip_info)
        )
      )

      user = User.create(user_attributes)
      admin_user = FactoryBot.create(:user, :random_name, is_admin: true)

      response '200', 'users found' do
        let(:id) { User.create(user_attributes).id }

        before { sign_in admin_user }

        example 'application/json', 'success response', {
          data: [{
            id: user.id,
            username: user.username,
            email: user.email,
            is_admin: user.is_admin,
            registration_ip_info: {
              address: user.registration_ip_info.address,
              latitude: user.registration_ip_info.latitude,
              longitude: user.registration_ip_info.longitude
            },
            created_at: user.created_at,
            updated_at: user.updated_at
          }]
        }

        run_test!
      end

      response '403', 'forbidden' do
        example 'application/json', 'failure response', {
          errors: [
            'forbidden'
          ]
        }

        run_test!
      end
    end
  end

  path '/users/{id}' do
    get 'user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      user_attributes = FactoryBot.attributes_for(
        :user,
        registration_ip_info: IpInfo.find_or_create_by(
          FactoryBot.attributes_for(:ip_info)
        )
      )

      user = User.create(user_attributes)

      parameter name: :id, in: :path, type: :integer

      response '200', 'user found' do
        let(:id) { User.create(user_attributes).id }

        example 'application/json', 'success response', {
          data: {
            id: user.id,
            username: user.username,
            email: user.email,
            is_admin: user.is_admin,
            registration_ip_info: {
              address: user.registration_ip_info.address,
              latitude: user.registration_ip_info.latitude,
              longitude: user.registration_ip_info.longitude
            },
            created_at: user.created_at,
            updated_at: user.updated_at
          }
        }

        run_test!
      end

      response '404', 'user not found' do
        let(:id) { User.count + 1 }

        example 'application/json', 'unfound response', {
          data: {}
        }

        run_test!
      end
    end
  end

  path '/users/{id}/visits' do
    get 'user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      time_format = '%Y.%m.%d %H:%M:%S'
      page = Page.find_or_create_by(FactoryBot.attributes_for(:page))

      user_attributes = FactoryBot.attributes_for(
        :user,
        registration_ip_info: IpInfo.find_or_create_by(
          FactoryBot.attributes_for(:ip_info)
        )
      )

      user = User.create(user_attributes)

      visit1 = FactoryBot.create(
        :visit,
        user:,
        ip_info: user.registration_ip_info,
        visited_at: Time.local(2024, 4, 3, 15)
      )

      visit2 = FactoryBot.create(
        :visit,
        user:,
        ip_info: user.registration_ip_info,
        page:,
        visited_at: Time.local(2024, 4, 4, 2, 50)
      )

      FactoryBot.create(
        :visit,
        user:,
        ip_info: user.registration_ip_info,
        visited_at: Time.local(2024, 4, 3, 14, 49)
      )

      parameter name: :id, in: :path, type: :integer

      parameter name: :page_id, in: :query, type: :integer, required: false

      parameter name: :from, in: :query, type: :string, required: false,
                default: '2024-04-06T16:13'

      parameter name: :to, in: :query, type: :string, required: false,
                default: '2024-04-07T16:13'

      response '200', 'visits found' do
        let(:id) { User.create(user_attributes).id }

        example 'application/json', 'success response', [
          {
            page_id: visit1.page_id,
            page_name: visit1.page.name,
            page_url: visit1.page.url,
            user_id: nil,
            visited_at: visit1.visited_at.strftime(time_format),
            ip_address: visit1.address,
            latitude: visit1.latitude.to_f,
            longitude: visit1.longitude.to_f
          },
          {
            page_id: visit2.page_id,
            page_name: visit1.page.name,
            page_url: visit1.page.url,
            user_id: visit2.user_id,
            visited_at: visit2.visited_at.strftime(time_format),
            ip_address: visit2.address,
            latitude: visit2.latitude.to_f,
            longitude: visit2.longitude.to_f
          }
        ]

        run_test!
      end
    end
  end
end
