# == Schema Information
#
# Table name: refunds
#
#  id            :integer          not null, primary key
#  purchase_id   :integer
#  settlement_id :integer
#  payment_id    :integer
#  state         :integer
#  settled       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Refund < ApplicationRecord
  belongs_to :purchase
  belongs_to :payment
  enum state: { pending: 0, completed: 1 }
end
