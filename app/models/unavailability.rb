class Unavailability < ActiveRecord::Base

  validates_presence_of :start_at
  validates_presence_of :end_at

  has_event_calendar

  belongs_to :user

  def start_at=(start_at)
    write_attribute(:start_at, (DateTime.strptime(start_at, DATETIME_FORMAT))) unless start_at.blank?
  end

  def end_at=(end_at)
    write_attribute(:end_at, (DateTime.strptime(end_at, DATETIME_FORMAT))) unless end_at.blank?
  end

  def name
    I18n.translate('unavailabilities.not_available')
  end

  def color
    return EVENT_COLOR_NOT_AVAILABLE
  end
  
end
