require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Visits', type: :request do
  path '/visits' do
    get 'list visits' do
      tags 'Visits'
      consumes 'application/json'
      produces 'application/json'

      ip_info = IpInfo.last || FactoryBot.create(:ip_info)
      page = Page.last || FactoryBot.create(:page)
      user = User.last ||
        FactoryBot.create(:user, registration_ip_info: ip_info)
      time_format = '%Y.%m.%d %H:%M:%S'

      visit1 = FactoryBot.create(
        :visit,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 15)
      )

      visit2 = FactoryBot.create(
        :visit,
        ip_info: ip_info,
        page: page,
        visited_at: Time.local(2024, 4, 4, 2, 50)
      )

      visit3 = FactoryBot.create(
        :visit,
        ip_info: ip_info,
        visited_at: Time.local(2024, 4, 3, 14, 49)
      )

      parameter name: :page_id, in: :query, type: :integer, required: false

      parameter name: :from, in: :query, type: :string, required: false,
        default: '2024-04-06T16:13'

      parameter name: :to, in: :query, type: :string, required: false,
        default: '2024-04-07T16:13'

      response '200', 'visits found' do
        example 'application/json', 'success response', [
          {
            page_id: visit1.page_id,
            user_id: nil,
            visited_at: visit1.visited_at.strftime(time_format),
            ip_address: visit1.address,
            latitude: visit1.latitude.to_f,
            longitude: visit1.longitude.to_f
          },
          {
            page_id: visit2.page_id,
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

    post 'create visit' do
      tags 'Visits'
      consumes 'application/json'
      produces 'application/json'

      page = Page.first || FactoryBot.create(:page)
      ip_info = IpInfo.last || FactoryBot.create(:ip_info)
      visited_at = Time.zone.now
      time_format = '%Y.%m.%d %H:%M:%S'

      visit = FactoryBot.build(
        :visit,
        page: page,
        ip_info: ip_info,
        visited_at: visited_at
      )

      parameter name: :visit, in: :body, schema: {
        type: :object,
        properties: {
          page_id: {
            type: :integer,
            default: page.id
          },
          user_id: {
            type: :integer,
            default: nil
          },
          visited_at: {
            type: :string,
            default: visited_at.strftime(time_format)
          },
          ip_info_attributes: {
            type: :object,
            properties: {
              address: {
                type: :string,
                default: ip_info.address
              }
            }
          }
        },
        required: [:page_id, :visited_at, :ip_info_attributes]
      }, required: true

      response '201', 'visit created' do
        let(:visit) do
          {
            page_id: page.id,
            user_id: nil,
            visited_at: visited_at.strftime(time_format),
            ip_info_attributes: {
              address: ip_info.address
            }
          }
        end

        example 'application/json', 'success response', {
          data: {
            page_id: visit.page_id,
            user_id: visit.user_id,
            visited_at: visit.visited_at.strftime(time_format),
            ip_address: visit.address,
            latitude: visit.latitude.to_f,
            longitude: visit.longitude.to_f
          }
        }

        run_test!
      end

      response '400', 'bad request' do
        let(:visit) do
          {
            page_id: page.id,
            user_id: nil,
            visited_at: visited_at.strftime(time_format),
          }
        end

        example 'application/json', 'failure response', {
          errors: [
            "an error has prevented the visit from being saved"
          ]
        }

        run_test!
      end
    end
  end
end
