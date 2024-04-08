# frozen_string_literal: true

class HomeController < ApplicationController
  def index
    render plain: 'page traffic API', status: :ok
  end
end
