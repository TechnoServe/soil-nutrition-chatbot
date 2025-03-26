class UserMailer < ApplicationMailer
  def send_otp(user)
    otp = user.otp_requests.active.last&.otp
    return unless otp

    postmark_client.deliver_with_template(
      from: from_email,
      to: user.email,
      template_alias: 'otp-verification',
      template_model: template_model_base.merge!({ otp: otp })
    )
  end

  def send_invitation(user)
    postmark_client.deliver_with_template(
      from: from_email,
      to: user.email,
      template_alias: 'user-invitation',
      template_model: template_model_base.merge!({ name: user.full_name,
                                                   redirection_url: "#{Rails.application.credentials[:be_url]}/users/sign_in" })
    )
  end
end
