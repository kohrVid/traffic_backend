# frozen_string_literal: true

# This controller contains endpoints that are associated with the User model
# but don't require Devise authentication
class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])

    render json: { data: UserSerializer.new(@user).serializable_hash }, status: :ok
  end

  def index
    @users = User.all

    data = @users&.map do |user|
      UserSerializer.new(user).serializable_hash
    end

    if current_user&.is_admin
      render json: { data: }, status: :ok
    else
      render json: { error: 'forbidden' }, status: :forbidden
    end
  end
end
