class CreateSalesReports < ActiveRecord::Migration[6.0]
  def change
    create_table :sales_reports do |t|
      t.references :user, index: true, foreign_key: true

      t.integer :income, default: 0
      t.string :status

      t.timestamps
    end
  end
end
