# == Schema Information
#
# Table name: credit_cards
#
#  id            :integer          not null, primary key
#  user_id       :integer
#  card_number   :string
#  card_provider :string
#  valid_up_to   :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class CreditCard < ApplicationRecord
  belongs_to :user
end
