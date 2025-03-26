module CmAdmin
  class ApplicationController < ActionController::Base
    include Authentication
    include ActiveStorage::SetCurrent
    before_action :authenticate_user!
    layout 'cm_admin'
    helper CmAdmin::ViewHelpers

    before_action :set_paper_trail_whodunnit

    def append_info_to_payload(payload)
      super
      payload[:user_id] = Current.user&.id
    end
  end
end
