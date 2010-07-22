class Contact < ActiveRecord::Base
  belongs_to :client
  has_many :events
  validates_presence_of :name
  validates_presence_of :phone
  validates_presence_of :client_id

  before_save :set_phone

  private

  def set_phone
    write_attribute :phone, (self.client.phone rescue '') if phone.blank?
  end
end
