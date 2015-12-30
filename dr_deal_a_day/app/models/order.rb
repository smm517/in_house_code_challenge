class Order < ActiveRecord::Base
  belongs_to :import
  belongs_to :merchant
  belongs_to :purchaser
  belongs_to :item

  def self.total_revenue
    connection.select_value(
      <<-SQL
        SELECT SUM(items.price)
        FROM items, orders
        WHERE orders.item_id = items.id
      SQL
    )
  end

end
