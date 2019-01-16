class CreatePayments < ActiveRecord::Migration[5.1]
  def change
    create_table :payments do |t|
      t.integer :mode
      t.string :ref_no
      t.string :refund_ref_no
      t.integer :payment_state
      t.integer :refund_state
      t.decimal :amount, precision: 10, scale: 2

      t.timestamps
    end
  end
end
