# frozen_string_literal: true

require 'rails_helper'
require 'swagger_helper'

RSpec.describe 'Home', type: :request do
  path '/' do
    get 'root' do
      tags '/'

      response '200', 'found' do
        example 'text/plain', 'success response',
                'page traffic API'

        run_test!
      end
    end
  end
end
