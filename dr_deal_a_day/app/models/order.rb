class Order < ActiveRecord::Base
  belongs_to :import
  belongs_to :merchant
  belongs_to :purchaser
  belongs_to :item
end
