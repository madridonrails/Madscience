# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def object_messages(obj = nil)
    if !obj.nil? && !obj.errors.blank?
      str_msg = '<div id="message" class="error"><span>' + obj.errors.full_messages.join('<br/>') + '</span></div>'
    elsif !flash[:error].blank?
      str_msg = '<div id="message" class="error"><span>' + flash[:error] + '</span></div>'
    elsif !flash[:notice].blank?
      str_msg = '<div id="message" class="notice"><span>' + flash[:notice] + '</span></div>'
    elsif !flash[:success].blank?
      str_msg = '<div id="message" class="success"><span>' + flash[:success] + '</span></div>'
    else
      str_msg = ''
    end
    flash[:error] = ''
    flash[:notice] = ''
    flash[:success] = ''
    return str_msg
  end

  def form_buttons(path_to_back, html_options={})
    "<li class=\"form-buttons #{html_options[:class]}\">
    <button type=\"submit\" class=\"positive\">
      #{image_tag 'icons/tick.png', :alt => t('general.ok'), :title => t('general.ok')}<span>#{t'general.ok'}</span>
    </button>
      #{link_to image_tag('icons/cross.png', :alt => t('general.cancel')) + 'Volver', path_to_back, :class => 'button negative', :title => t('general.cancel')}
    </li>"
  end

  def image_and_text(image, text)
    image_tag(image, :alt => text, :title => text) + text
  end

  def parse_date_from_database(datetime)
    DateTime.strptime(datetime, DATETIME_DATABASE_FORMAT).strftime(DATE_FORMAT)
  end
end
