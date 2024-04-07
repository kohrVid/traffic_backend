require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Users::Sessions', type: :request do
  path '/users/auth' do
    get 'authenticate user' do
      tags 'Users'
      consumes 'application/json'
      produces 'application/json'

      ip_info = IpInfo.last || FactoryBot.create(:ip_info)
      user = User.last ||
        FactoryBot.create(:user, registration_ip_info: ip_info)

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
            "unauthorised"
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

      ip_info = IpInfo.last || FactoryBot.create(:ip_info)
      user1 = User.create(FactoryBot.attributes_for(:user, registration_ip_info: ip_info))

      parameter name: :body, in: :body, schema: { 
        type: :object,
        properties: {
          user: {
            type: :object,
            properties: {
              email: { 
                type: :string,
                default: user1.email
              },
              password: { 
                type: :string,
                default: 'Password1234!'
              },
            },
            required: [
              :email,
              :password
            ]
          }
        }
      }, required: true

      response '201', 'user signed in' do
        before { user1 }

        let(:body) do
          {
            user: {
              email: user1.email,
              password: 'Password1234!'
            }
          }
        end

        example 'application/json', 'success response', {
          data: "successfully logged in"
        }

        run_test!
      end

      response '401', 'unauthorised' do
        let(:user) do
          {
            user: {
              email: user1.email,
              password: 'wrongPassword123'
            }
          }
        end

        example 'application/json', 'failure response', {
          errors: [
            "failed authentication"
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

        example 'application/json', 'success response', { }

        run_test!
      end
    end
  end
end
