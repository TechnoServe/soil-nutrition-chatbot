class ApplicationController < ActionController::Base
  include ActiveStorage::SetCurrent

  def health_check
    render plain: 'OK'
  end
end
