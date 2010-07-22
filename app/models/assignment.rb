class Assignment < ActiveRecord::Base

  belongs_to :user
  belongs_to :event

  validates_presence_of :user_id
  validates_presence_of :event_id
  validates_presence_of :aasm_state

  validates_numericality_of :user_id, :allow_blank => true, :greater_than => 0, :only_integer => true
  validates_numericality_of :event_id, :allow_blank => true, :greater_than => 0, :only_integer => true

  include AASM

  aasm_state :pendant #initial
  aasm_state :denied #by admin
  aasm_state :accepted #by admin
  aasm_state :canceled #by the user
#  aasm_state :confirmed #by the user

  aasm_initial_state :pendant

  aasm_event :solicitate do
    transitions :to => :pendant, :from => [:canceled]
  end

  aasm_event :accept do
    transitions :to => :accepted, :from => [:pendant, :denied]
  end

  aasm_event :deny do
    transitions :to => :denied, :from => [:pendant, :accepted, :confirmed, :canceled]
  end

=begin
  aasm_event :confirm do
    transitions :to => :confirmed, :from => [:accepted]#, :exit => [:decrement_vacancies]
  end
=end

  aasm_event :cancel do
    transitions :to => :canceled, :from => [:confirmed, :accepted, :pendant]
  end

end
