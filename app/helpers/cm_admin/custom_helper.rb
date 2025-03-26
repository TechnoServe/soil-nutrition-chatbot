module CmAdmin
  module CustomHelper
    def select_options_for_cm_role(_ = nil, _ = nil)
      ::CmRole.pluck(:name, :id)
    end

    ::Constant::CONSTANT_TYPES.each do |constant_type|
      define_method "select_options_for_#{constant_type}" do |_ = nil, _ = nil|
        ::Constant.send(constant_type).order(name: :asc).all.map { |c| [c.display_name, c.id] }
      end
    end

    def select_options_for_constant_types(_ = nil, _ = nil)
      ::Constant::CONSTANT_TYPES.map { |name| [name.titleize, name] }
    end

    def select_options_for_all_constants(_ = nil, _ = nil)
      ::Constant.pluck(:name, :id)
    end

    def evaluation_result_url(record, field_name)
      link = record.send(field_name)
      return unless link.present?

      content_tag :a, href: link, target: '_blank' do
        'Results ↗️'
      end
    end

    def file_url(record, field_name)
      link = record.send(field_name)
      return unless link.present?

      content_tag :a, href: link, target: '_blank' do
        'PDF File ↗️'
      end
    end
  end
end
