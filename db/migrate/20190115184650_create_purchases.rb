class CreatePurchases < ActiveRecord::Migration[5.1]
  def change
    create_table :purchases do |t|
      t.references :product, foreign_key: true
      t.references :buyer, foreign_key: { to_table: :users }
      t.references :seller, foreign_key: { to_table: :users }
      t.references :payment, foreign_key: true
      t.references :settlement, foreign_key: true
      t.integer :state, default: 0
      t.boolean :settled, default: false

      t.timestamps
    end
  end
end
