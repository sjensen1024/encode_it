class AddFieldsToEncodedItems < ActiveRecord::Migration[8.0]
  def change
    add_column :encoded_items, :placement, :string
  end
end
