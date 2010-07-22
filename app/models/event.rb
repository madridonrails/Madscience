class Event < ActiveRecord::Base
  belongs_to :client
  belongs_to :contact
  has_event_calendar

  has_many :assignments
  has_many :users, :through => :assignments

  attr_protected :assignments_accepted

  validates_presence_of :code
  validates_presence_of :client_id
  validates_presence_of :start_at
  validates_presence_of :end_at
  validates_presence_of :address
  validates_presence_of :resources
  validates_numericality_of :resources, :allow_blank => true, :greater_than => 0, :only_integer => true
  validates_uniqueness_of :code

  before_save :set_address

  def start_at=(start_at)
    write_attribute(:start_at, (DateTime.strptime(start_at, DATETIME_FORMAT))) unless start_at.blank?
  end

  def end_at=(end_at)
    write_attribute(:end_at, (DateTime.strptime(end_at, DATETIME_FORMAT))) unless end_at.blank?
  end

  def color
    if complete?
      return EVENT_COLOR_COMPLETE
    elsif incomplete?
      return EVENT_COLOR_INCOMPLETE
    elsif over_assigned?
      return EVENT_COLOR_OVER_ASSIGNED
    end
  end

  def vacancies
    resources - assignments_accepted rescue 0
  end

  def complete?
    vacancies == 0
  end

  def incomplete?
    vacancies > 0
  end

  def over_assigned?
    vacancies < 0
  end

  def user_assigned!
    self.assignments_accepted += 1
    self.save!
  end

  def user_removed!
    self.assignments_accepted -= 1
    self.save!
  end

  def users_assigned
    self.assignments.collect{|a| a.user if a.accepted?}.compact
  end

  private

  def set_address
    write_attribute :address, (client.address rescue 'Sin dirección') if address.blank?
  end

end
