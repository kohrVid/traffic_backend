# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users::Sessions', type: :request do
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  path '/users/auth' do
    get 'authenticate user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      user_attributes = FactoryBot.attributes_for(
        :user,
        registration_ip_info: IpInfo.find_or_create_by(
          FactoryBot.attributes_for(:ip_info)
        )
      )

      user = User.find_by(username: user_attributes[:username]) ||
             User.create(user_attributes)

      response '200', 'user authenticated' do
        before { sign_in user }

        example 'application/json', 'success response', {
          data: {
            id: 1,
            current_user: user.username,
            is_admin: user.is_admin
          }
        }

        run_test!
      end

      response '401', 'unauthorised' do
        example 'application/json', 'failure response', {
          errors: [
            'unauthorised'
          ]
        }

        run_test!
      end
    end
  end

  path '/users/sign_in' do
    post 'sign in user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      user_attributes = FactoryBot.attributes_for(:user, :random_name)
      before { User.create(user_attributes) }

      parameter name: :body, in: :body, schema: {
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: {
                type: :string,
                default: user_attributes[:email]
              },
              password: {
                type: :string,
                default: user_attributes[:password]
              }
            },
            required: %i[
              email
              password
            ]
          }
        }
      }, required: true

      response '201', 'user signed in' do
        let(:body) do
          {
            user: {
              email: user_attributes[:email],
              password: user_attributes[:password]
            }
          }
        end

        example 'application/json', 'success response', {
          data: 'successfully logged in'
        }

        run_test!
      end

      response '401', 'unauthorised' do
        let(:user) do
          {
            user: {
              email: user_attributes[:email],
              password: 'wrongPassword123'
            }
          }
        end

        example 'application/json', 'failure response', {
          errors: [
            'failed authentication'
          ]
        }

        run_test!
      end
    end
  end

  path '/users/sign_out' do
    delete 'sign out user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      user = User.last || FactoryBot.create(:user)

      response '204', 'user signed out' do
        before { sign_in user }

        example 'application/json', 'success response', {}

        run_test!
      end
    end
  end
end
