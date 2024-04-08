# frozen_string_literal: true

# This controller contains endpoints that are associated with the User model
# but don't require Devise authentication
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    render json: { data: @user.as_json }, status: :ok
  end
end
