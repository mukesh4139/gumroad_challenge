# == Schema Information
#
# Table name: purchases
#
#  id            :integer          not null, primary key
#  product_id    :integer
#  buyer_id      :integer
#  seller_id     :integer
#  payment_id    :integer
#  settlement_id :integer
#  state         :integer          default("draft")
#  settled       :boolean          default(FALSE)
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class Purchase < ApplicationRecord
  belongs_to :product
  belongs_to :buyer, class_name: 'User'
  belongs_to :seller, class_name: 'User'
  belongs_to :payment
  has_one :refund

  enum state: { draft: 0, purchased: 1, refunded: 2 }

  after_save :handle_purchase
  after_save :handle_refund

  def handle_purchase
    if saved_change_to_state == %w(draft purchased)
      seller.increase_balance(payment.amount)
    end
  end

  def handle_refund
    if saved_change_to_state == %w(purchased refunded)
      refund = self.build_refund({
        payment_id: payment_id,
        state: :pending,
      })
      refund.save!
    end 
  end
end
