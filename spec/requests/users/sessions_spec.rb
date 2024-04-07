require 'rails_helper'

RSpec.describe "Users::Sessions", type: :request do
  describe 'GET /users/auth' do
    scenario 'the user is authenticated' do
      get users_auth_path

      expect(response).to have_http_status(200)

      expect(
        JSON.parse(response.body)
      ).to include("data" => [
        {
          "id" => page1.id,
          "name" => page1.name,
         "url" => page1.url
        },
        {
          "id" => page2.id,
          "name" => page2.name,
          "url" => page2.url
        }
      ])
    end

    scenario 'the user is not authenticated' do
      get users_auth_path

      expect(response).to have_http_status(401)

      expect(
        JSON.parse(response.body)
      ).to include("data" => [
        {
          "id" => page1.id,
          "name" => page1.name,
         "url" => page1.url
        },
        {
          "id" => page2.id,
          "name" => page2.name,
          "url" => page2.url
        }
      ])
    end
  end
end

