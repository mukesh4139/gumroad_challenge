module WeeklyPayout
  def self.execute
    today_date = Time.zone.now.beginning_of_day + 1.day
    start_date = today_date - 7.days
    end_date = today_date
    date_range = start_date...end_date
    # Consider only those users whose payout_day is today and has balance not equal to 0
    users = User.where(payout_day: today_date.wday).where('balance != ?', 0)

    users.each do |user|
      purchases = user.purchases.where(created_at: date_range, state: [:purchased, :refunded], settlement_id: nil)
      refunds = Refund.joins(:purchase).where(purchases: { seller_id: user.id }, created_at: date_range, settlement_id: nil)
      purchases_amount = purchases.includes(:payment).map { |purchase| purchase.payment.amount }.reduce(:+)
      refunds_amount = refunds.includes(:payment).map { |refund| refund.payment.amount }.reduce(:+)
      net_amount = purchases_amount - refunds_amount

      settlement = Settlement.new({
        state: :pending,
        amount: user.balance
      })

      if settlement.save!
        user.decrease_balance(net_amount)
        purchases.update_all(settlement_id: settlement.id)
        refunds.update_all(settlement_id: settlement.id)
      else
        Rails.logger.warn("Some Issues Encountered while settling user: #{user.id}")  
      end
    end

  rescue StandardError => error
    Rails.logger.warn("Error Encountered: #{error}")
  end  
end
