class Import < ActiveRecord::Base
  require 'csv'

  has_many :orders, dependent: :destroy

  validates_presence_of :file_name

  def self.run_import(file_path, original_filename, options = {})

    duplicate_filename_import = Import.where(file_name: original_filename).first

    if duplicate_filename_import.present?
      raise DuplicateFileNameError.new(duplicate_filename_import.id)
    end

    if options[:using_tsv]
      csv = CSV.read(file_path, headers: true, header_converters: :symbol, col_sep: "\t")
    else
      csv = CSV.read(file_path, headers: true, header_converters: :symbol)
    end


    import = Import.create!(file_name: original_filename)

    csv.each_with_index do |row, i|

      purchaser = Purchaser.where(name: row[:purchaser_name]).first
      purchaser = Purchaser.new(name: row[:purchaser_name]) if purchaser.nil?

      merchant = Merchant.where(name: row[:merchant_name], address: row[:merchant_address]).first
      merchant = Merchant.new(name: row[:merchant_name], address: row[:merchant_address]) if merchant.nil?

      item = Item.where(name: row[:item_description], price: row[:item_price]).first
      item = Item.new(name: row[:item_description], price: row[:item_price]) if item.nil?

      if (!purchaser.valid? || !merchant.valid? || !item.valid?)
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

    import
  end


  def to_csv(options = {})
    if options[:using_tsv]
      options = { col_sep: "\t" }
    end

    header = ["purchaser name", "item description", "item price", "purchase count", "merchant address", "merchant name"]
    CSV.generate(options.merge(headers: true)) do |csv|
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
        SELECT SUM(items.price * orders.quantity)
        FROM items, orders
        WHERE orders.item_id = items.id
          AND orders.import_id = #{self.id}
      SQL
    ).to_f
  end

  def self.total_revenue
    return 0 if Import.all.empty?

    connection.select_value(
      <<-SQL
        SELECT SUM(items.price * orders.quantity)
        FROM items, orders
        WHERE orders.item_id = items.id
      SQL
    ).to_f
  end

  class EmptyDataFileError < StandardError
    def initialize
      super("Error: file contains no data.")
    end
  end
  class InvalidDataError < StandardError
    def initialize(row_number)
      super("Error: file contains invalid or missing data in row #{row_number}")
    end
  end
  class DuplicateFileNameError < StandardError
    attr_reader :duplicate_import_id

    def initialize(import_id)
      super("A previous import has the same file name as the file you have selected. After ensuring that your file does not have the same data as the previous import, please upload it with a different file name.")
      @duplicate_import_id = import_id
    end
  end

end
