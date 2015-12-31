class Import < ActiveRecord::Base
  require 'csv'

  has_many :orders

  def self.run_import(file)

    csv = CSV.read(file.path, headers: true, header_converters: :symbol)
    import = Import.create!(file_name: file.original_filename)

    csv.each_with_index do |row, i|

      purchaser = Purchaser.where(name: row[:purchaser_name]).first
      purchaser = Purchaser.new(name: row[:purchaser_name]) if purchaser.nil?

      merchant = Merchant.where(name: row[:merchant_name], address: row[:merchant_address]).first
      merchant = Merchant.new(name: row[:merchant_name], address: row[:merchant_address]) if merchant.nil?

      item = Item.where(name: row[:item_description], price: row[:item_price]).first
      item = Item.new(name: row[:item_description], price: row[:item_price]) if item.nil?

      if (!purchaser.valid? || !merchant.valid? || !item.valid?)
        import.orders.destroy_all
        import.destroy!
        raise InvalidDataError.new(i+1) # don't use zero based indexing for end users
      end

      purchaser.save
      merchant.save
      item.save
      Order.create!(import_id: import.id, merchant_id: merchant.id, item_id: item.id, purchaser_id: purchaser.id, quantity: row[:purchase_count])
    end

    if import.orders.empty?
      import.destroy!
      raise EmptyDataFileError.new
    end
  end


  def to_csv
    header = ["purchaser name", "item description", "item price", "purchase count", "merchant address", "merchant name"]

    CSV.generate(headers: true) do |csv|
      csv << header

      self.orders.each do |order|
        csv << [order.purchaser.name, order.item.name, order.item.price, order.quantity, order.merchant.address, order.merchant.name]
      end
    end
  end

  def revenue
    return 0 if self.orders.empty?

    Import.connection.select_value(
      <<-SQL
        SELECT SUM(items.price)
        FROM items, orders
        WHERE orders.item_id = items.id
          AND orders.import_id = #{self.id}
      SQL
    )
  end

  def self.total_revenue
    return 0 if Import.all.empty?

    connection.select_value(
      <<-SQL
        SELECT SUM(items.price)
        FROM items, orders
        WHERE orders.item_id = items.id
      SQL
    )
  end

  class EmptyDataFileError < StandardError
    def initialize
      super("Error: File contains no data.")
    end
  end
  class InvalidDataError < StandardError
    def initialize(row_number)
      super("Error: File contains invalid or missing data in row #{row_number}")
    end
  end

end
