class CreateCreditCards < ActiveRecord::Migration[5.1]
  def change
    create_table :credit_cards do |t|
      t.references :user, foreign_key: true
      t.string :card_number
      t.string :card_provider
      t.date :valid_up_to

      t.timestamps
    end
  end
end
