# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

100.times do |_i|
  User.create!(
    name: Faker::Name.name,
    email: Faker::Internet.email,
    payout_day: rand(7)
  )
end


70.times do |_i|
  Product.create!(
    name: Faker::Commerce.product_name,
    user_id: 1 + rand(User.last.id),
    price: Faker::Commerce.price,
    description: Faker::Lorem.sentence,
  )
end

50.times do |_i|
  CreditCard.create!(
    card_number: Faker::Bank.account_number(16),
    card_provider: Faker::Bank.name,
    valid_up_to: Faker::Date.between(Date.today + 5.year, Date.today + 10.year),
    user_id: 1 + rand(User.last.id),
  )
end

1000.times do |_i|
  product = Product.find(1 + rand(Product.last.id))
  state = 'purchased' || %w(draft purchased refunded)[rand(3)]
  payment = Payment.create!(
    mode: 0,
    ref_no: %w(purchased refunded).include?(state) ? Faker::Invoice.reference : nil,
    refund_ref_no: %w(refunded).include?(state) ? Faker::Invoice.creditor_reference : nil,
    payment_state: %w(purchased refunded).include?(state) ? 'completed' : 'pending',
    refund_state: %w(refunded).include?(state) ? %w(refund_pending refund_completed)[rand(2)] : nil,
    amount: product.price
  )

  purchase = Purchase.create!(
    product_id: 1 + rand(Product.last.id),
    buyer_id: 1 + rand(User.last.id),
    seller_id: 1 + rand(10),
    payment_id: payment.id,
    state: state
  )

  if state == 'refunded'
    Refund.create!(
      purchase_id: purchase.id,
      payment_id: payment.id,
      state: payment.refund_state
    )
  end  
end
