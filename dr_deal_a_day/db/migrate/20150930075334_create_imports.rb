class CreateImports < ActiveRecord::Migration
  def change
    create_table :imports do |t|
      t.string "file_name"

      t.timestamps null: false
    end
  end
end
