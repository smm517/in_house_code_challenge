class Item < ActiveRecord::Base
  has_many :orders

  validates_presence_of :name, :price
end
