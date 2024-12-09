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

ActiveRecord::Schema[7.2].define(version: 2024_10_28_084240) do
  create_table "active_storage_attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "adrs", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "name"
  end

  create_table "adrs_disposal_types", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "adr_id", unsigned: true
    t.integer "disposal_type_id", unsigned: true
    t.index ["adr_id"], name: "fk_adrdt_adr"
    t.index ["disposal_type_id"], name: "fk_adrdt_dt"
  end

  create_table "buildings", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.string "name", null: false
    t.text "address"
    t.text "description"
    t.index ["organization_id"], name: "organization_id"
  end

  create_table "cer_codes", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name", limit: 100
    t.text "description"
    t.boolean "danger", default: false
    t.index ["name"], name: "name"
  end

  create_table "cer_codes_suppliers", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "cer_code_id", null: false, unsigned: true
    t.integer "supplier_id", null: false, unsigned: true
    t.index ["cer_code_id"], name: "fk_ccs_cer_code"
    t.index ["supplier_id"], name: "fk_ccs_supplier"
  end

  create_table "compliances", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.text "name"
    t.text "description"
    t.integer "year", unsigned: true
    t.text "url"
  end

  create_table "containers", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.column "name", "enum('tanica','bidone polietilene','clinipack','fusto','big bag')"
    t.integer "volume"
    t.text "notes"
  end

  create_table "containers_disposal_types", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "container_id", null: false, unsigned: true
    t.integer "disposal_type_id", null: false, unsigned: true
    t.index ["container_id"], name: "container_id"
    t.index ["disposal_type_id"], name: "disposal_type_id"
  end

  create_table "contracts", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "supplier_id", null: false, unsigned: true
    t.integer "cer_code_id", null: false, unsigned: true
    t.decimal "price", precision: 6, scale: 2, default: "0.0", unsigned: true
    t.date "start_date"
    t.date "end_date"
    t.index ["cer_code_id"], name: "cer_code_id"
    t.index ["supplier_id"], name: "supplier_id"
  end

  create_table "disposal_types", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "organization_id", unsigned: true
    t.integer "compliance_id", unsigned: true
    t.integer "cer_code_id", unsigned: true
    t.integer "un_code_id", unsigned: true
    t.column "physical_state", "enum('liq','sp','snp')"
    t.boolean "separable", default: false, null: false
    t.boolean "hidden", default: false, null: false
    t.boolean "legalizable", default: false, null: false
    t.text "notes"
    t.text "compliance_alert"
    t.timestamp "created_at"
    t.index ["cer_code_id"], name: "fk_disposal_types_cer"
    t.index ["compliance_id"], name: "fw_compliances_disposal_types"
    t.index ["organization_id"], name: "fk_disposal_types_organization"
    t.index ["un_code_id"], name: "fk_disposal_types_un"
  end

  create_table "disposal_types_hp_codes", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "disposal_type_id", unsigned: true
    t.integer "hp_code_id", unsigned: true
    t.index ["disposal_type_id"], name: "fk_dthc_disposal"
    t.index ["hp_code_id"], name: "fk_dthc_hp_code"
  end

  create_table "disposal_types_pictograms", id: false, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "disposal_type_id", unsigned: true
    t.integer "pictogram_id", unsigned: true
    t.index ["disposal_type_id"], name: "fk_dtp_dt"
    t.index ["pictogram_id"], name: "fk_dtp_picto"
  end

  create_table "disposals", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "user_id", unsigned: true
    t.integer "lab_id", unsigned: true
    t.integer "picking_id", unsigned: true
    t.integer "producer_id", unsigned: true
    t.boolean "multiple_users", default: false
    t.integer "organization_id", unsigned: true
    t.integer "disposal_type_id", unsigned: true
    t.integer "legal_record_id", unsigned: true
    t.text "notes"
    t.decimal "kgs", precision: 10, scale: 3, default: "0.0"
    t.integer "volume"
    t.integer "container_id", unsigned: true
    t.integer "units", limit: 2, default: 1
    t.date "created_at"
    t.date "approved_at"
    t.date "legalized_at"
    t.date "delivered_at"
    t.date "completed_at"
    t.index ["container_id"], name: "container_id"
    t.index ["disposal_type_id"], name: "fk_disposals_disposal_type"
    t.index ["lab_id"], name: "fk_disposals_labs"
    t.index ["legal_record_id"], name: "legal_record_id"
    t.index ["organization_id"], name: "fk_disposals_organizations"
    t.index ["picking_id"], name: "fk_disposals_pickings"
    t.index ["producer_id"], name: "fk_disposals_producers"
    t.index ["user_id"], name: "fk_disposals_users"
  end

  create_table "hazards", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code", limit: 20, null: false
    t.text "phrase", null: false
    t.column "category", "enum('Fisico','Salute','Ambiente')", null: false
  end

  create_table "hp_codes", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.index ["name"], name: "name"
  end

  create_table "labs", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "building_id", unsigned: true
    t.integer "organization_id", unsigned: true
    t.string "name"
    t.index ["building_id"], name: "building_id"
    t.index ["organization_id"], name: "fk_labs_organizations"
  end

  create_table "legal_records", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.column "type", "enum('LegalUpload','LegalDownload')"
    t.integer "organization_id", null: false, unsigned: true
    t.integer "disposal_type_id", null: false, unsigned: true
    t.integer "picking_document_id", unsigned: true
    t.integer "year", null: false, unsigned: true
    t.date "date"
    t.integer "number", null: false, unsigned: true
    t.date "created_at"
    t.date "updated_at"
    t.index ["disposal_type_id"], name: "disposal_type_id"
    t.index ["number"], name: "k_number"
    t.index ["organization_id", "year", "number"], name: "organization_id", unique: true
    t.index ["picking_document_id"], name: "picking_document_id"
  end

  create_table "organizations", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "description"
    t.string "adminmail", limit: 200
    t.datetime "updated_at", precision: nil
    t.datetime "created_at", precision: nil
  end

  create_table "permissions", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
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

  create_table "picking_documents", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "picking_id", null: false, unsigned: true
    t.integer "disposal_type_id", null: false, unsigned: true
    t.string "serial_number"
    t.decimal "kgs", precision: 10, scale: 3, default: "0.0"
    t.decimal "volume", precision: 10, scale: 3
    t.index ["disposal_type_id"], name: "fk_picking_document_disposal_type"
    t.index ["picking_id", "disposal_type_id"], name: "picking_id", unique: true
    t.index ["picking_id"], name: "fk_picking_document_picking"
  end

  create_table "pickings", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "organization_id", null: false, unsigned: true
    t.integer "supplier_id", null: false, unsigned: true
    t.date "date"
    t.text "address"
    t.text "contact"
    t.datetime "created_at", precision: nil
    t.date "delivered_at"
    t.date "completed_at"
    t.index ["organization_id"], name: "fk_pickings_organizations"
    t.index ["supplier_id"], name: "fk_pickings_suppliers"
  end

  create_table "pictograms", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "filename"
  end

  create_table "suppliers", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "name"
    t.string "pi"
    t.text "address"
  end

  create_table "un_codes", id: { type: :integer, unsigned: true, default: nil }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "name"
  end

  create_table "users", id: { type: :integer, unsigned: true }, charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "upn", limit: 150
    t.string "gender", limit: 1
    t.string "name", limit: 50
    t.string "surname", limit: 50
    t.string "email"
    t.integer "employee_id", unsigned: true
    t.timestamp "updated_at", default: -> { "current_timestamp() ON UPDATE current_timestamp()" }, null: false
    t.index ["upn"], name: "index_dsacaches_on_upn", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "adrs_disposal_types", "adrs", name: "fk_adrdt_adr"
  add_foreign_key "adrs_disposal_types", "disposal_types", name: "fk_adrdt_dt"
  add_foreign_key "buildings", "organizations", name: "buildings_ibfk_1"
  add_foreign_key "cer_codes_suppliers", "cer_codes", name: "fk_ccs_cer_code"
  add_foreign_key "cer_codes_suppliers", "suppliers", name: "fk_ccs_supplier"
  add_foreign_key "containers_disposal_types", "containers", name: "containers_disposal_types_ibfk_1"
  add_foreign_key "containers_disposal_types", "disposal_types", name: "containers_disposal_types_ibfk_2"
  add_foreign_key "contracts", "cer_codes", name: "contracts_ibfk_2"
  add_foreign_key "contracts", "suppliers", name: "contracts_ibfk_1"
  add_foreign_key "disposal_types", "cer_codes", name: "fk_disposal_types_cer"
  add_foreign_key "disposal_types", "compliances", name: "fw_compliances_disposal_types"
  add_foreign_key "disposal_types", "organizations", name: "fk_disposal_types_organization"
  add_foreign_key "disposal_types", "un_codes", name: "fk_disposal_types_un"
  add_foreign_key "disposal_types_hp_codes", "disposal_types", name: "fk_dthc_disposal"
  add_foreign_key "disposal_types_hp_codes", "hp_codes", name: "fk_dthc_hp_code"
  add_foreign_key "disposal_types_pictograms", "disposal_types", name: "fk_dtp_dt"
  add_foreign_key "disposal_types_pictograms", "pictograms", name: "fk_dtp_picto"
  add_foreign_key "disposals", "containers", name: "disposals_ibfk_2"
  add_foreign_key "disposals", "disposal_types", name: "fk_disposals_disposal_type"
  add_foreign_key "disposals", "labs", name: "fk_disposals_labs"
  add_foreign_key "disposals", "legal_records", name: "disposals_ibfk_1"
  add_foreign_key "disposals", "organizations", name: "fk_disposals_organizations"
  add_foreign_key "disposals", "pickings", name: "fk_disposals_pickings"
  add_foreign_key "disposals", "users", column: "producer_id", name: "fk_disposals_producers"
  add_foreign_key "disposals", "users", name: "fk_disposals_users"
  add_foreign_key "labs", "buildings", name: "labs_ibfk_1"
  add_foreign_key "labs", "organizations", name: "fk_labs_organizations"
  add_foreign_key "legal_records", "disposal_types", name: "legal_records_ibfk_2", on_delete: :cascade
  add_foreign_key "legal_records", "organizations", name: "legal_records_ibfk_1", on_delete: :cascade
  add_foreign_key "legal_records", "picking_documents", name: "legal_records_ibfk_3", on_delete: :cascade
  add_foreign_key "permissions", "organizations", name: "fk_organization_permission"
  add_foreign_key "permissions", "users", column: "producer_id", name: "fk_permission_producer"
  add_foreign_key "permissions", "users", name: "fk_user_permission"
  add_foreign_key "picking_documents", "disposal_types", name: "fk_picking_document_disposal_type"
  add_foreign_key "picking_documents", "pickings", name: "fk_picking_document_picking"
  add_foreign_key "pickings", "organizations", name: "fk_pickings_organizations"
  add_foreign_key "pickings", "suppliers", name: "fk_pickings_suppliers"
end
