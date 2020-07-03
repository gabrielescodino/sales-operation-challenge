class CreateUsers < ActiveRecord::Migration[6.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :google_uid
      t.string :google_token
      t.timestamps
    end
  end
end
