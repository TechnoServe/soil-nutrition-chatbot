require 'devise/strategies/authenticatable'
module Devise
  module Strategies
    class PasswordlessAuthenticatable < Authenticatable
      def authenticate!
        return unless params[:user].present?

        user = User.find_by(email: params[:user][:email])
        user.create_otp_request if user.can_access_admin_panel?
        encoded_email = URI.encode_www_form_component(params[:user][:email])
        redirect!("/sign_in_with_otp?email=#{encoded_email}")
      end
    end
  end
end
Warden::Strategies.add(:passwordless_authenticatable, Devise::Strategies::PasswordlessAuthenticatable)
