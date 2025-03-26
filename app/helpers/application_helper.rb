module ApplicationHelper
  def translate_index_field_header(header)
    if header == 'Sample'
      'Muestra'
    elsif header == 'Fertigation'
      'Fertilización'
    else
      header
    end
  end
end
