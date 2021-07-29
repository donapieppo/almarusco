# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 0) do

  create_table "cer_codes", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 100
    t.text "description"
    t.boolean "danger"
    t.index ["name"], name: "name"
  end

  create_table "cer_codes_suppliers", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.integer "cer_code_id", unsigned: true
    t.integer "supplier_id"
    t.index ["cer_code_id"], name: "fk_ccs_cer_code"
    t.index ["supplier_id"], name: "fk_ccs_supplier"
  end

  create_table "disposal_types", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "organization_id"
    t.integer "cer_code_id", unsigned: true
    t.integer "un_code_id", unsigned: true
    t.boolean "adr"
    t.column "physical_state", "enum('liq','sp','snp')"
    t.text "notes"
    t.index ["cer_code_id"], name: "fk_disposal_types_cer"
    t.index ["organization_id"], name: "fk_disposal_types_organization"
    t.index ["un_code_id"], name: "fk_disposal_types_un"
  end

  create_table "disposal_types_hp_codes", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.integer "disposal_type_id", unsigned: true
    t.integer "hp_code_id", unsigned: true
    t.index ["disposal_type_id"], name: "fk_dthc_disposal"
    t.index ["hp_code_id"], name: "fk_dthc_hp_code"
  end

  create_table "disposals", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "organization_id"
    t.integer "disposal_type_id", unsigned: true
    t.text "notes"
    t.decimal "kgs", precision: 10, scale: 3
    t.decimal "liters", precision: 10, scale: 3
    t.date "created_at"
    t.date "approved_at"
    t.index ["disposal_type_id"], name: "fk_disposals_disposal_type"
    t.index ["organization_id"], name: "fk_disposals_organizations"
    t.index ["user_id"], name: "fk_disposals_users"
  end

  create_table "hp_codes", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "name"
  end

  create_table "organizations", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "adminmail", limit: 200
    t.datetime "updated_at"
    t.datetime "created_at"
  end

  create_table "permissions", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "organization_id"
    t.string "network", limit: 20
    t.integer "authlevel"
    t.datetime "updated_at"
    t.datetime "created_at"
    t.index ["organization_id"], name: "fk_organization_permission"
    t.index ["user_id"], name: "fk_user_permission"
  end

  create_table "suppliers", id: :integer, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "pi"
  end

  create_table "un_codes", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", force: :cascade do |t|
    t.text "name"
  end

  create_table "users", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "upn", limit: 150
    t.string "gender", limit: 1
    t.string "name", limit: 50
    t.string "surname", limit: 50
    t.string "email"
    t.integer "employee_id"
    t.timestamp "updated_at", default: -> { "current_timestamp()" }, null: false
    t.index ["upn"], name: "index_dsacaches_on_upn", unique: true
  end

  create_table "volumes", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "num", unsigned: true
    t.integer "liters", unsigned: true
    t.integer "disposal_id", unsigned: true
    t.index ["disposal_id"], name: "fk_dv_disposal"
  end

  add_foreign_key "cer_codes_suppliers", "cer_codes", name: "fk_ccs_cer_code"
  add_foreign_key "cer_codes_suppliers", "suppliers", name: "fk_ccs_supplier"
  add_foreign_key "disposal_types", "cer_codes", name: "fk_disposal_types_cer"
  add_foreign_key "disposal_types", "organizations", name: "fk_disposal_types_organization"
  add_foreign_key "disposal_types", "un_codes", name: "fk_disposal_types_un"
  add_foreign_key "disposal_types_hp_codes", "disposal_types", name: "fk_dthc_disposal"
  add_foreign_key "disposal_types_hp_codes", "hp_codes", name: "fk_dthc_hp_code"
  add_foreign_key "disposals", "disposal_types", name: "fk_disposals_disposal_type"
  add_foreign_key "disposals", "organizations", name: "fk_disposals_organizations"
  add_foreign_key "disposals", "users", name: "fk_disposals_users"
  add_foreign_key "permissions", "organizations", name: "fk_organization_permission"
  add_foreign_key "permissions", "users", name: "fk_user_permission"
  add_foreign_key "volumes", "disposals", name: "fk_dv_disposal"
end
