class ApplicationMailer < ActionMailer::Base
  default from: Rails.configuration.x.project_settings.default_from_email
  layout 'mailer'

  def template_model_base
    @template_model_base ||= {
      project_name: Rails.configuration.x.project_settings.name,
      logo_url: Rails.configuration.x.project_settings.logo_url,
      current_year: Date.today.year.to_s
    }
  end

  def from_email
    environment_prefix = case Rails.env
                         when 'development'
                           '[DEV] '
                         when 'staging'
                           '[STG] '
                         when 'production'
                           ''
                         else
                           "[#{Rails.env}]"
                         end
    postmark_from_email = Rails.configuration.x.project_settings.default_from_email
    @from_email ||= "#{environment_prefix}#{Rails.configuration.x.project_settings.name}<#{postmark_from_email}>"
  end

  def postmark_client
    postmark_key = Rails.application.credentials.dig(:postmark, :api_token)
    @postmark_client ||= Postmark::ApiClient.new(postmark_key)
  end
end
