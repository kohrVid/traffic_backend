# frozen_string_literal: true

class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    render json: { data: @user.as_json }, status: :ok
  end
end
