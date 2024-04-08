# frozen_string_literal: true

# Home contoller used for miscellaneous API endpoints
class HomeController < ApplicationController
  def index
    render plain: 'page traffic API', status: :ok
  end
end
