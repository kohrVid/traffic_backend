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
        let(:id) {  User.create(user_attributes).id }

        example 'application/json', 'success response', {
          data: {
            id: user.id,
            username: user.username,
            email: user.email,
            is_admin: user.is_admin,
            registration_ip_info_id: user.registration_ip_info_id,
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
end
