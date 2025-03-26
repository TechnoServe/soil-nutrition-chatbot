module CmAdmin
  module InorganicRecommendationRow
    extend ActiveSupport::Concern

    included do
      cm_admin do
        actions only: []
        set_icon 'fa fa-database'
        visible_on_sidebar false

        cm_index do
          page_title '1a Deliverable Row'
        end
      end
    end
  end
end
