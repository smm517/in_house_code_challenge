class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.references :import
      t.references :merchant
      t.references :item
      t.references :purchaser
      t.integer :quantity

      t.timestamps null: false
    end
  end
end
