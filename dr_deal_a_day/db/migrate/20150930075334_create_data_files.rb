class CreateDataFiles < ActiveRecord::Migration
  def change
    create_table :data_files do |t|
      t.string "file_name"
      t.text "file_contents"

      t.timestamps null: false
    end
  end
end
