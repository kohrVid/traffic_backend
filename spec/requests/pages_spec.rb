require 'rails_helper'

RSpec.describe "Pages", type: :request do
  let(:page1) { create(:page) }
  let(:page2) { create(:page, name: 'contact') }

  before do
    page1
    page2
  end

  describe 'GET /index' do
    scenario 'a list of pages is returned' do
      get pages_path

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
  end
end
