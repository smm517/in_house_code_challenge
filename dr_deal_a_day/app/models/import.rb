class Import < ActiveRecord::Base
  require 'csv'

  has_many :orders

  def self.run_import(file)

    import = Import.create!(file_name: file.original_filename)

    CSV.foreach(file.path, headers: true, header_converters: :symbol) do |row|

      purchaser = Purchaser.where(name: row[:purchaser_name]).first
      purchaser = Purchaser.new(name: row[:purchaser_name]) if purchaser.nil?

      merchant = Merchant.where(name: row[:merchant_name], address: row[:merchant_address]).first
      merchant = Merchant.new(name: row[:merchant_name], address: row[:merchant_address]) if merchant.nil?

      item = Item.where(name: row[:item_description], price: row[:item_price]).first
      item = Item.new(name: row[:item_description], price: row[:item_price]) if item.nil?

      purchaser.save!
      merchant.save!
      item.save!

      Order.create!(import_id: import.id, merchant_id: merchant.id, item_id: item.id, purchaser_id: purchaser.id, quantity: row[:purchase_count])

    end

    # TODO error handling
  end

  def revenue
    Import.connection.select_value(
      <<-SQL
        SELECT SUM(items.price)
        FROM items, orders
        WHERE orders.item_id = items.id
          AND orders.import_id = #{self.id}
      SQL
    )
  end

end
