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

ActiveRecord::Schema[7.0].define(version: 0) do
  create_table "adrs", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "name"
  end

  create_table "adrs_disposal_types", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.integer "adr_id", unsigned: true
    t.integer "disposal_type_id", unsigned: true
    t.index ["adr_id"], name: "fk_adrdt_adr"
    t.index ["disposal_type_id"], name: "fk_adrdt_dt"
  end

  create_table "cer_codes", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name", limit: 100
    t.text "description"
    t.boolean "danger", default: false
    t.index ["name"], name: "name"
  end

  create_table "cer_codes_suppliers", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.integer "cer_code_id", null: false, unsigned: true
    t.integer "supplier_id", null: false, unsigned: true
    t.index ["cer_code_id"], name: "fk_ccs_cer_code"
    t.index ["supplier_id"], name: "fk_ccs_supplier"
  end

  create_table "disposal_types", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.integer "cer_code_id", unsigned: true
    t.integer "un_code_id", unsigned: true
    t.boolean "adr", default: false
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

  create_table "disposal_types_pictograms", id: false, charset: "utf8mb4", force: :cascade do |t|
    t.integer "disposal_type_id", unsigned: true
    t.integer "pictogram_id", unsigned: true
    t.index ["disposal_type_id"], name: "fk_dtp_dt"
    t.index ["pictogram_id"], name: "fk_dtp_picto"
  end

  create_table "disposals", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "lab_id", unsigned: true
    t.integer "picking_id", unsigned: true
    t.integer "producer_id", unsigned: true
    t.integer "organization_id", unsigned: true
    t.integer "disposal_type_id", unsigned: true
    t.text "notes"
    t.decimal "kgs", precision: 10, scale: 3
    t.integer "volume"
    t.date "created_at"
    t.date "approved_at"
    t.date "delivered_at"
    t.index ["disposal_type_id"], name: "fk_disposals_disposal_type"
    t.index ["lab_id"], name: "fk_disposals_labs"
    t.index ["organization_id"], name: "fk_disposals_organizations"
    t.index ["picking_id"], name: "fk_disposals_pickings"
    t.index ["producer_id"], name: "fk_disposals_producers"
    t.index ["user_id"], name: "fk_disposals_users"
  end

  create_table "hp_codes", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "name"
  end

  create_table "labs", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.string "name"
    t.index ["organization_id"], name: "fk_labs_organizations"
  end

  create_table "organizations", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "adminmail", limit: 200
    t.datetime "updated_at", precision: nil
    t.datetime "created_at", precision: nil
  end

  create_table "permissions", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "organization_id", unsigned: true
    t.string "network", limit: 20
    t.integer "authlevel", unsigned: true
    t.datetime "updated_at", precision: nil
    t.datetime "created_at", precision: nil
    t.integer "producer_id", unsigned: true
    t.date "expiry"
    t.index ["organization_id"], name: "fk_organization_permission"
    t.index ["producer_id"], name: "fk_permission_producer"
    t.index ["user_id"], name: "fk_user_permission"
  end

  create_table "picking_documents", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "picking_id", null: false, unsigned: true
    t.integer "disposal_type_id", null: false, unsigned: true
    t.string "serial_number"
    t.integer "register_number"
    t.decimal "kgs", precision: 10, scale: 3
    t.decimal "volume", precision: 10, scale: 3
    t.index ["disposal_type_id"], name: "fk_picking_document_disposal_type"
    t.index ["picking_id"], name: "fk_picking_document_picking"
  end

  create_table "pickings", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.integer "organization_id", null: false, unsigned: true
    t.integer "supplier_id", null: false, unsigned: true
    t.date "date"
    t.datetime "created_at", precision: nil
    t.date "delivered_at"
    t.index ["organization_id"], name: "fk_pickings_organizations"
    t.index ["supplier_id"], name: "fk_pickings_suppliers"
  end

  create_table "pictograms", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "filename"
  end

  create_table "suppliers", id: { type: :integer, unsigned: true }, charset: "utf8mb4", force: :cascade do |t|
    t.string "name"
    t.string "pi"
    t.text "address"
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
    t.integer "employee_id", unsigned: true
    t.timestamp "updated_at", default: -> { "current_timestamp() ON UPDATE current_timestamp()" }, null: false
    t.index ["upn"], name: "index_dsacaches_on_upn", unique: true
  end

  add_foreign_key "adrs_disposal_types", "adrs", name: "fk_adrdt_adr"
  add_foreign_key "adrs_disposal_types", "disposal_types", name: "fk_adrdt_dt"
  add_foreign_key "cer_codes_suppliers", "cer_codes", name: "fk_ccs_cer_code"
  add_foreign_key "cer_codes_suppliers", "suppliers", name: "fk_ccs_supplier"
  add_foreign_key "disposal_types", "cer_codes", name: "fk_disposal_types_cer"
  add_foreign_key "disposal_types", "organizations", name: "fk_disposal_types_organization"
  add_foreign_key "disposal_types", "un_codes", name: "fk_disposal_types_un"
  add_foreign_key "disposal_types_hp_codes", "disposal_types", name: "fk_dthc_disposal"
  add_foreign_key "disposal_types_hp_codes", "hp_codes", name: "fk_dthc_hp_code"
  add_foreign_key "disposal_types_pictograms", "disposal_types", name: "fk_dtp_dt"
  add_foreign_key "disposal_types_pictograms", "pictograms", name: "fk_dtp_picto"
  add_foreign_key "disposals", "disposal_types", name: "fk_disposals_disposal_type"
  add_foreign_key "disposals", "labs", name: "fk_disposals_labs"
  add_foreign_key "disposals", "organizations", name: "fk_disposals_organizations"
  add_foreign_key "disposals", "pickings", name: "fk_disposals_pickings"
  add_foreign_key "disposals", "users", column: "producer_id", name: "fk_disposals_producers"
  add_foreign_key "disposals", "users", name: "fk_disposals_users"
  add_foreign_key "labs", "organizations", name: "fk_labs_organizations"
  add_foreign_key "permissions", "organizations", name: "fk_organization_permission"
  add_foreign_key "permissions", "users", column: "producer_id", name: "fk_permission_producer"
  add_foreign_key "permissions", "users", name: "fk_user_permission"
  add_foreign_key "picking_documents", "disposal_types", name: "fk_picking_document_disposal_type"
  add_foreign_key "picking_documents", "pickings", name: "fk_picking_document_picking"
  add_foreign_key "pickings", "organizations", name: "fk_pickings_organizations"
  add_foreign_key "pickings", "suppliers", name: "fk_pickings_suppliers"
end
