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

ActiveRecord::Schema.define(version: 2021_01_21_220938) do

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
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "ethnicities", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "municipalities", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.integer "state_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name", "state_id"], name: "municipalities_name_state_id_key", unique: true
  end

  create_table "parties", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.text "shortname", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["shortname"], name: "parties_shortname_key", unique: true
  end

  create_table "politician_occupations", id: :serial, force: :cascade do |t|
    t.integer "year", null: false
    t.text "tse_ue"
    t.text "tse_candidate_number"
    t.integer "politician_id", null: false
    t.integer "role_id", null: false
    t.integer "state_id", null: false
    t.integer "municipality_id", null: false
    t.integer "party_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "politicians", id: :serial, force: :cascade do |t|
    t.text "cpf", null: false
    t.text "name", null: false
    t.text "nickname"
    t.text "email"
    t.text "nationality"
    t.date "birthdate"
    t.text "gender"
    t.text "marital_status"
    t.text "education_level"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ethnicity_id"
    t.index ["cpf"], name: "politicians_cpf_key", unique: true
    t.check_constraint "education_level = ANY (ARRAY['ensino médio completo'::text, 'superior completo'::text, 'ensino fundamental completo'::text, 'ensino fundamental incompleto'::text, 'lê e escreve'::text, 'ensino médio incompleto'::text, 'superior incompleto'::text, 'analfabeto'::text, 'other'::text])", name: "politicians_education_level_check"
    t.check_constraint "gender = ANY (ARRAY['male'::text, 'female'::text, 'other'::text])", name: "politicians_gender_check"
    t.check_constraint "marital_status = ANY (ARRAY['single'::text, 'married'::text, 'divorced'::text, 'other'::text])", name: "politicians_marital_status_check"
    t.check_constraint "nationality = ANY (ARRAY['brasileira'::text, 'other'::text])", name: "politicians_nationality_check"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "roles_name_key", unique: true
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "states_name_key", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "municipalities", "states", name: "municipalities_state_id_fkey", on_delete: :cascade
  add_foreign_key "politician_occupations", "municipalities", name: "politician_occupations_municipality_id_fkey", on_delete: :cascade
  add_foreign_key "politician_occupations", "parties", name: "politician_occupations_party_id_fkey", on_delete: :cascade
  add_foreign_key "politician_occupations", "politicians", name: "politician_occupations_politician_id_fkey", on_delete: :cascade
  add_foreign_key "politician_occupations", "roles", name: "politician_occupations_role_id_fkey", on_delete: :cascade
  add_foreign_key "politician_occupations", "states", name: "politician_occupations_state_id_fkey", on_delete: :cascade
  add_foreign_key "politicians", "ethnicities"
end
