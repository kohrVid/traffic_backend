# frozen_string_literal: true

# The PagesController is used to return the list of pages in the frontend
# application that have tracking enabled for page visits.
class PagesController < ApplicationController
  def index
    @pages = Page.all.map do |page|
      PageSerializer.new(page).serializable_hash
    end

    render json: { data: @pages }, status: :ok
  end
end
