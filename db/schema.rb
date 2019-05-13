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

ActiveRecord::Schema.define(version: 2019_05_13_025056) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "postal_code", limit: 8, null: false
    t.string "neighborhood", limit: 255, null: false
    t.string "city", limit: 255, null: false
    t.string "state", limit: 2, null: false
    t.boolean "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.string "street", limit: 255, null: false
    t.string "number", limit: 10, null: false
    t.index ["member_id"], name: "index_addresses_on_member_id"
  end

  create_table "emails", force: :cascade do |t|
    t.string "email_address", limit: 100, null: false
    t.boolean "primary"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.index ["member_id"], name: "index_emails_on_member_id"
  end

  create_table "ensemble_levels", force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.integer "precedence_order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ensembles", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.date "foundation_date"
    t.text "history"
    t.bigint "ensemble_level_id", null: false
    t.bigint "ensemble_parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ensemble_level_id"], name: "index_ensembles_on_ensemble_level_id"
    t.index ["ensemble_parent_id"], name: "index_ensembles_on_ensemble_parent_id"
  end

  create_table "identity_document_types", force: :cascade do |t|
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identity_documents", force: :cascade do |t|
    t.string "number"
    t.string "complement"
    t.bigint "identity_document_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.index ["identity_document_type_id"], name: "index_identity_documents_on_identity_document_type_id"
    t.index ["member_id"], name: "index_identity_documents_on_member_id"
  end

  create_table "leaderships", force: :cascade do |t|
    t.date "appointment_date"
    t.boolean "primary"
    t.bigint "ensemble_id", null: false
    t.bigint "member_id", null: false
    t.bigint "position_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ensemble_id"], name: "index_leaderships_on_ensemble_id"
    t.index ["member_id"], name: "index_leaderships_on_member_id"
    t.index ["position_id"], name: "index_leaderships_on_position_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.date "joining_date"
    t.date "birthdate"
    t.string "food_restrictions", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "organizational_information_id"
    t.bigint "ensemble_id"
    t.string "complement"
    t.index ["ensemble_id"], name: "index_members_on_ensemble_id"
    t.index ["organizational_information_id"], name: "index_members_on_organizational_information_id"
  end

  create_table "organizational_informations", force: :cascade do |t|
    t.string "associated_code", limit: 10, null: false
    t.date "convertion_date"
    t.string "position", limit: 100
    t.string "study_level", limit: 100
    t.integer "conversions_made", default: 0
    t.boolean "discussion_meeting", default: false
    t.boolean "sustaining_contribution", default: false
    t.boolean "publications_subscription", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phone_types", force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "phones", force: :cascade do |t|
    t.string "phone_number", limit: 20, null: false
    t.bigint "phone_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.boolean "primary"
    t.index ["member_id"], name: "index_phones_on_member_id"
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "addresses", "members"
  add_foreign_key "emails", "members"
  add_foreign_key "ensembles", "ensemble_levels"
  add_foreign_key "ensembles", "ensembles", column: "ensemble_parent_id"
  add_foreign_key "identity_documents", "identity_document_types"
  add_foreign_key "identity_documents", "members"
  add_foreign_key "leaderships", "ensembles"
  add_foreign_key "leaderships", "members"
  add_foreign_key "leaderships", "positions"
  add_foreign_key "members", "ensembles"
  add_foreign_key "members", "organizational_informations"
  add_foreign_key "phones", "members"
  add_foreign_key "phones", "phone_types"
end
