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

ActiveRecord::Schema.define(version: 2019_09_03_003244) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

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
    t.string "additional_information", limit: 100
    t.index ["member_id"], name: "index_addresses_on_member_id"
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
    t.boolean "leadership_purpose"
    t.index ["ensemble_level_id"], name: "index_ensembles_on_ensemble_level_id"
    t.index ["ensemble_parent_id"], name: "index_ensembles_on_ensemble_parent_id"
  end

  create_table "identity_document_types", force: :cascade do |t|
    t.string "description", limit: 25
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "identity_documents", force: :cascade do |t|
    t.string "number", limit: 100
    t.string "complement", limit: 25
    t.bigint "identity_document_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "member_id", null: false
    t.index ["identity_document_type_id"], name: "index_identity_documents_on_identity_document_type_id"
    t.index ["member_id"], name: "index_identity_documents_on_member_id"
  end

  create_table "leader_roles", force: :cascade do |t|
    t.string "additional_information", limit: 100
    t.boolean "primary"
    t.bigint "position_id", null: false
    t.bigint "leader_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["leader_id"], name: "index_leader_roles_on_leader_id"
    t.index ["position_id"], name: "index_leader_roles_on_position_id"
  end

  create_table "leaders", force: :cascade do |t|
    t.date "appointment_date"
    t.boolean "primary"
    t.bigint "ensemble_id", null: false
    t.bigint "member_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ensemble_id", "member_id"], name: "index_leaders_on_ensemble_id_and_member_id", unique: true
    t.index ["ensemble_id"], name: "index_leaders_on_ensemble_id"
    t.index ["member_id"], name: "index_leaders_on_member_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", limit: 100, null: false
    t.date "joining_date"
    t.date "birthdate"
    t.string "food_restrictions", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "ensemble_id"
    t.text "additional_information"
    t.bigint "membership_id"
    t.string "email", limit: 100
    t.index ["ensemble_id"], name: "index_members_on_ensemble_id"
    t.index ["membership_id"], name: "index_members_on_membership_id"
  end

  create_table "memberships", id: :integer, default: nil, force: :cascade do |t|
    t.string "name", limit: 100
    t.date "joining_date"
    t.string "organizational_position", limit: 50
    t.string "study_level", limit: 50
    t.boolean "sustaining_contribution", default: false
    t.jsonb "discussion_meeting", default: {}, null: false
    t.jsonb "publications_subscriptions", default: {}, null: false
    t.jsonb "members_sponsored", default: {}, null: false
    t.jsonb "organizational_information", default: {}, null: false
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
    t.string "additional_information", limit: 100
    t.index ["member_id"], name: "index_phones_on_member_id"
    t.index ["phone_type_id"], name: "index_phones_on_phone_type_id"
  end

  create_table "positions", force: :cascade do |t|
    t.string "description", limit: 100, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "precedence_order"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "access_level", default: "member", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "addresses", "members"
  add_foreign_key "ensembles", "ensemble_levels"
  add_foreign_key "ensembles", "ensembles", column: "ensemble_parent_id"
  add_foreign_key "identity_documents", "identity_document_types"
  add_foreign_key "identity_documents", "members"
  add_foreign_key "leader_roles", "leaders"
  add_foreign_key "leader_roles", "positions"
  add_foreign_key "leaders", "ensembles"
  add_foreign_key "leaders", "members"
  add_foreign_key "members", "ensembles"
  add_foreign_key "members", "memberships"
  add_foreign_key "phones", "members"
  add_foreign_key "phones", "phone_types"
end
