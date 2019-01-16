module WeeklyPayout
  #
  # This is a job, which can be scheduled to run once a day.
  # Steps followed can be briefly pointed out as follows:
  # 0. Set time period of last 1 week
  # 1. Filter out all the users whose payout day is today and has balance not equal to 0.
  # 2. Now, for each user, filter out all the purchases on the time period in the state "purchased" and "refunded"
  #    because they are only going to be considered for settlement. Also apply filter settlement_id should be nil.
  # 3. Similarly, filter out all the refunds on the time period.
  # 4. Aggregate the purchases amount and refunds amount.
  # 5. Calculate Net Amount: purchases - refunds.
  # 6. Create a new settlement for the user.
  # 7. Deduct the net amount from the current balance of the user.
  # 8. Add Settlement Id to all the purchases and refunds that were filtered out.
  # 

  def self.execute
    today_date = Time.zone.now.beginning_of_day + 1.day
    start_date = today_date - 7.days
    end_date = today_date
    date_range = start_date...end_date
    users = User.where(payout_day: today_date.wday).where('balance != ?', 0)

    users.each do |user|
      purchases = user.purchases.where(created_at: date_range, state: [:purchased, :refunded], settlement_id: nil)
      refunds = Refund.joins(:purchase).where(purchases: { seller_id: user.id }, created_at: date_range, settlement_id: nil)
      purchases_amount = purchases.includes(:payment).map { |purchase| purchase.payment.amount }.reduce(:+)
      refunds_amount = refunds.includes(:payment).map { |refund| refund.payment.amount }.reduce(:+)
      purchases_amount = 0 if purchases_amount.nil?
      refunds_amount = 0 if refunds_amount.nil?
      net_amount = purchases_amount - refunds_amount

      settlement = Settlement.new({
        state: :pending,
        amount: user.balance,
        user_id: user.id
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
