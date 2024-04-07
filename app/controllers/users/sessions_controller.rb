# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  include ActionController::MimeResponds
  # before_action :configure_sign_in_params, only: [:create]

  respond_to :json

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    self.resource = warden.authenticate(auth_options)

    if self.resource.nil?
      render json: { errors: ['failed authentication'] }, status: :unauthorized

      return
    end

    sign_in self.resource
    session[:user_id] = self.resource.id
    render json: { data: 'successfully logged in' }, status: :created
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  def show
    if user_signed_in? && current_user
      data = { current_user: current_user.username, id: current_user.id }
      data[:is_admin] = current_user.is_admin?
      headers['Last-Modified'] = Time.now.httpdate

      render json: { data: data }, status: :ok
    else
      render json: { errors: ["unauthorised"] }, status: :unauthorized
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end