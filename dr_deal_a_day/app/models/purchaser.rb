class Purchaser < ActiveRecord::Base
  has_many :orders

  validates_presence_of :name
end
