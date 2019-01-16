class CreateRefunds < ActiveRecord::Migration[5.1]
  def change
    create_table :refunds do |t|
      t.references :purchase, foreign_key: true
      t.references :settlement, foreign_key: true
      t.references :payment, foreign_key: true
      t.integer :state
      t.boolean :settled, default: false
    
      t.timestamps
    end
  end
end
