# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string
#  email      :string
#  balance    :decimal(10, 2)   default(0.0)
#  payout_day :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class User < ApplicationRecord
  has_many :purchases, foreign_key: :seller_id
  
  enum payout_day: { sun: 0, mon: 1, tues: 2, wed: 3, thu: 4, fri: 5, sat: 6 }

  #
  # These two functions keeps updating user's balance depending upon the case.
  #

  def increase_balance(amount = 0.0)
    balance = self.balance + amount
    self.update(balance: balance)
  end

  def decrease_balance(amount = 0.0)
    balance = self.balance - amount
    self.update(balance: balance)
  end
end
