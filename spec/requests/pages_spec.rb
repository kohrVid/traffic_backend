# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Pages', type: :request do
  path '/pages' do
    get 'list pages' do
      tags 'Pages'
      consumes 'application/json'
      produces 'application/json'

      page1 = Page.first || FactoryBot.create(:page)
      page2 = Page.second || FactoryBot.create(:page)

      response '200', 'pages found' do
        example 'application/json', 'success response', [
          {
            id: page1.id,
            name: page1.name,
            url: page1.url
          },
          {
            id: page2.id,
            name: page2.name,
            url: page2.url
          }
        ]

        run_test!
      end
    end
  end
end
