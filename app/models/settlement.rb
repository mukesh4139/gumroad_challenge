# == Schema Information
#
# Table name: settlements
#
#  id         :integer          not null, primary key
#  amount     :decimal(10, 2)
#  state      :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Settlement < ApplicationRecord
  enum state: { pending: 0, completed: 1 }
end
