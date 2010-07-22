class Client < ActiveRecord::Base

  has_many :activities, :dependent => :nullify
  has_many :events
  has_many :contacts

  validates_presence_of :name
#  validates_presence_of :cif
  
end
