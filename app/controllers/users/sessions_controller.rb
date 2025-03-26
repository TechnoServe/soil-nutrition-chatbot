# frozen_string_literal: true

module Users
  class SessionsController < Devise::SessionsController
    def create
      user = User.find_by!(email: params.dig(:user, :email))
      if user.can_access_admin_panel?
        self.resource = warden.authenticate!(auth_options)
        set_flash_message(:notice, :signed_in) if is_navigational_format?
        sign_in(resource_name, resource)
        if !session[:return_to].blank?
          redirect_to session[:return_to]
          session[:return_to] = nil
        else
          respond_with resource, location: after_sign_in_path_for(resource)
        end
      else
        flash[:alert] = 'User not authorized to access admin panel'
        redirect_back(fallback_location: 'users/sign_in')
      end
    rescue ActiveRecord::RecordNotFound
      flash[:alert] = 'Your email is not registered'
      redirect_back(fallback_location: 'users/sign_in')
    end

    def new
      self.resource = resource_class.new(sign_in_params)
      clean_up_passwords(resource)
      yield resource if block_given?
      if sign_in_params.blank?
        respond_with(resource, serialize_options(resource))
      else
        redirect_to sign_in_with_otp_path(email: resource.email)
      end
    end

    def validate_otp
      user = User.find_by(email: params[:email])
      otp = params[:otp]
      if user.present? && (user.verify_otp(otp) || user.valid_password?(otp))
        sign_in(user)
        flash[:success] = 'Success'
        redirect_to current_user&.cm_role&.default_redirect_path || '/cm_admin/users'
      else
        flash[:alert] = 'OTP is wrong'
        redirect_back(fallback_location: sign_in_with_otp_path(email: params[:email]))
      end
    end

    def resend_otp
      user = User.find_by(email: params[:email])
      user.create_otp_request if user.present?
      respond_to do |format|
        flash[:success] = 'OTP is sent successfully'
        format.html { redirect_to sign_in_with_otp_path(email: params[:email]) }
      end
    end

    def sign_in_with_otp
      @email = params[:email]
    end
  end
end
