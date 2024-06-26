# frozen_string_literal: true

module Users
  # This controller mostly inherits from the Devise RegistrationsController but
  # contains an endpoint that has been refactored to support JSON requests
  class RegistrationsController < Devise::RegistrationsController
    include ActionController::MimeResponds
    before_action :configure_sign_up_params, only: [:create]
    # before_action :configure_account_update_params, only: [:update]
    # GET /resource/sign_up
    # def new
    #   super
    # end

    # POST /resource
    def create
      respond_to do |format|
        format.json do
          build_resource(devise_parameter_sanitizer.sanitize(:registration))

          if resource.save
            render status: :created, json: { data: resource }
          else
            render json: { errors: resource.errors },
                   status: :unprocessable_entity
          end
        end
      end
    end

    # GET /resource/edit
    # def edit
    #   super
    # end

    # PUT /resource
    # def update
    #   super
    # end

    # DELETE /resource
    # def destroy
    #   super
    # end

    # GET /resource/cancel
    # Forces the session data which is usually expired after sign
    # in to be expired now. This is useful if the user wants to
    # cancel oauth signing in/up in the middle of the process,
    # removing all OAuth session data.
    # def cancel
    #   super
    # end

    protected

    def configure_sign_up_params
      devise_parameter_sanitizer.permit(
        :registration,
        keys: [
          :username,
          :email,
          :password,
          :password_confirmation,
          {
            registration_ip_info_attributes: [
              :address
            ],
            user: [
              :username,
              :email,
              :password,
              :password_confirmation,
              {
                registration_ip_info_attributes: [
                  :address
                ]
              }
            ]
          }
        ]
      )
    end

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_account_update_params
    #   devise_parameter_sanitizer.permit(:account_update, keys: [:attribute])
    # end

    # The path used after sign up.
    # def after_sign_up_path_for(resource)
    #   super(resource)
    # end

    # The path used after sign up for inactive accounts.
    # def after_inactive_sign_up_path_for(resource)
    #   super(resource)
    # end
  end
end
