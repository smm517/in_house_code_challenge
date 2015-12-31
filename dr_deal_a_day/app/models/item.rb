class Item < ActiveRecord::Base
  has_many :orders

  validates_presence_of :name, :price
  validates_numericality_of :price
end
