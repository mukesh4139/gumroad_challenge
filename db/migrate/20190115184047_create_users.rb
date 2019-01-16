class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.decimal :balance, precision: 10, scale: 2, default: 0, index: true
      t.integer :payout_day, index: true

      t.timestamps
      
    end
  end
end
