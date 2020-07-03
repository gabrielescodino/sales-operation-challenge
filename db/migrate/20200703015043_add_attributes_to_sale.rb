class AddAttributesToSale < ActiveRecord::Migration[6.0]
  def change
    add_column :sales, :purchase_count, :integer
    add_column :sales, :item_price, :integer
  end
end
