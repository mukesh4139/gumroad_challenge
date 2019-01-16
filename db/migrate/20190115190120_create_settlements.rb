class CreateSettlements < ActiveRecord::Migration[5.1]
  def change
    create_table :settlements do |t|
      t.decimal :amount, precision: 10, scale: 2
      t.integer :state

      t.timestamps
    end
  end
end
