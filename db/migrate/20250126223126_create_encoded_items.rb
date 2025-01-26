class CreateEncodedItems < ActiveRecord::Migration[8.0]
  def change
    create_table :encoded_items do |t|
      t.string :descriptor
      t.string :value

      t.timestamps
    end
  end
end
