class PagesController < ApplicationController
  def index
    @pages = Page.all.map do |page|
      PageSerializer.new(page).serializable_hash
    end

    render json: { data: @pages }, status: :ok
  end
end
