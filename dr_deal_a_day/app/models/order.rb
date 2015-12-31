class Order < ActiveRecord::Base
  belongs_to :import
  belongs_to :merchant
  belongs_to :purchaser
  belongs_to :item

  validates_presence_of :import_id, :merchant_id, :purchaser_id, :item_id
end
