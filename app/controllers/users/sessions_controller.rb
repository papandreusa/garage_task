# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super do
      cookies.signed['user.id'] = current_user.id
      cookies.signed['user.expires_at'] = 30.minutes.from_now
    end
  end

  # DELETE /resource/sign_out
  def destroy
    super do
      cookies.signed['user.id'] = nil
      cookies.signed['user.expires_at'] = nil
    end
  end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
