require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users::Registrations', type: :request do
  let(:ip_location) { double(:ip_location) }

  before do
    allow(IpLocation).to receive(:new)
      .and_return(ip_location)

    allow(ip_location).to receive(:coordinates)
      .and_return([])

    allow(ip_location).to receive(:vpn?).and_return(false)
  end

  path '/users' do
    post 'new user registration' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      new_user = FactoryBot.attributes_for(
        :user,
        registration_ip_info: IpInfo.find_or_create_by(
          FactoryBot.attributes_for(:ip_info)
        )
      )

      parameter name: :user, in: :body, schema: { 
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { 
                type: :string,
                default: new_user[:email]
              },
              username: { 
                type: :string,
                default: new_user[:username]
              },
              password: { 
                type: :string,
                default: new_user[:password]
              },
              password_confirmation: { 
                type: :string,
                default: new_user[:password_confirmation]
              },
              registration_ip_info_attributes: {
                type: :object,
                properties: {
                  address: { 
                    type: :string,
                    default: new_user[:registration_ip_info].address
                  }
                }
              }
            },
            required: [
              :username,
              :email,
              :password,
              :password_confirmation,
              :registration_ip_info_attributes
            ]
          }
        },
        required: [:user]
      }

      response '201', 'user created' do
        let(:user) do
          {
            user: {
              username: new_user[:username],
              email: new_user[:email],
              password: new_user[:password],
              password_confirmation: new_user[:password_confirmation],
              registration_ip_info_attributes: {
                address: new_user[:registration_ip_info].address
              }
            }
          }
        end

        example 'application/json', 'success response', {
          data: {
            id: 1,
            username: new_user[:username],
            email: new_user[:email],
            is_admin: new_user[:is_admin],
            registration_ip_info_id: new_user[:registration_ip_info].id,
            created_at: "2024-04-07T17:13:30.981Z",
            updated_at: "2024-04-07T17:13:30.981Z"
          }
        }

        run_test!
      end

      response '422', 'unprocessable content' do
        let(:user) do
          {
            user: {}
          }
        end

        example 'application/json', 'missing email', {
          errors: [
            {
              email: [
                "can't be blank"
              ]
            }
          ]
        }

        example 'application/json', 'missing username', {
          errors: [
            {
              username: [
                "can't be blank"
              ]
            }
          ]
        }

        example 'application/json', 'missing password', {
          errors: [
            {
              password: [
                "can't be blank"
              ]
            }
          ]
        }

        example 'application/json', 'missing IP address', {
          errors: [
            {
              "registration_ip_info.address": [
                "can't be blank"
              ]
            }
          ]
        }

        example 'application/json', 'duplicate email', {
          errors: [
            {
              email: [
                "has already been taken"
              ]
            }
          ]
        }

        example 'application/json', 'duplicate username', {
          errors: [
            {
              username: [
                "has already been taken"
              ]
            }
          ]
        }

        run_test!
      end
    end
  end
end
