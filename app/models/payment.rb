# == Schema Information
#
# Table name: payments
#
#  id            :integer          not null, primary key
#  mode          :integer
#  ref_no        :string
#  refund_ref_no :string
#  payment_state :integer
#  refund_state  :integer
#  amount        :decimal(10, 2)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Payment < ApplicationRecord
  enum payment_states: { pending: 0, completed: 1 }
  enum refund_states: { refund_pending: 0, refund_completed: 1 }
end
