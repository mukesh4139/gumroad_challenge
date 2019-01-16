# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190115190120) do

  create_table "credit_cards", force: :cascade do |t|
    t.integer "user_id"
    t.string "card_number"
    t.string "card_provider"
    t.date "valid_up_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_credit_cards_on_user_id"
  end

  create_table "payments", force: :cascade do |t|
    t.integer "mode"
    t.string "ref_no"
    t.string "refund_ref_no"
    t.integer "payment_state"
    t.integer "refund_state"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.decimal "price", precision: 10, scale: 2
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_products_on_user_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.integer "product_id"
    t.integer "buyer_id"
    t.integer "seller_id"
    t.integer "payment_id"
    t.integer "settlement_id"
    t.integer "state", default: 0
    t.boolean "settled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["buyer_id"], name: "index_purchases_on_buyer_id"
    t.index ["payment_id"], name: "index_purchases_on_payment_id"
    t.index ["product_id"], name: "index_purchases_on_product_id"
    t.index ["seller_id"], name: "index_purchases_on_seller_id"
    t.index ["settlement_id"], name: "index_purchases_on_settlement_id"
  end

  create_table "refunds", force: :cascade do |t|
    t.integer "purchase_id"
    t.integer "settlement_id"
    t.integer "payment_id"
    t.integer "state"
    t.boolean "settled", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["payment_id"], name: "index_refunds_on_payment_id"
    t.index ["purchase_id"], name: "index_refunds_on_purchase_id"
    t.index ["settlement_id"], name: "index_refunds_on_settlement_id"
  end

  create_table "settlements", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.integer "state"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_settlements_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.decimal "balance", precision: 10, scale: 2, default: "0.0"
    t.integer "payout_day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["balance"], name: "index_users_on_balance"
    t.index ["payout_day"], name: "index_users_on_payout_day"
  end

end
