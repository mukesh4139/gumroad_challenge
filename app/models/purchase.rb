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

  # 3 states has been maintained for the purchase
  enum state: { draft: 0, purchased: 1, refunded: 2 }

  
  after_save :handle_purchase
  after_save :handle_refund

  #
  # User's Balance is altered when a new purchase is created and state of the is purchased.
  # When a purchase go from state draft to purchased, seller's balance is increased by the amount
  # equal to payment's amount(which is equal to product's amount).
  #

  def handle_purchase
    if saved_change_to_state == %w(draft purchased)
      seller.increase_balance(payment.amount)
    end
  end

  #
  # User's Balance is altered when a purchase is refunded.
  # When a purchase go from state purchased to refunded, A refund object is created with the same 
  # payment id that is present in purchase.
  # The seller's balance is decreased by the amount equal to payment's amount.
  #

  def handle_refund
    if saved_change_to_state == %w(purchased refunded)
      refund = self.build_refund({
        payment_id: payment_id,
        state: :pending,
      })
      refund.save!
      seller.decrease_balance(payment.amount)
    end 
  end
end
