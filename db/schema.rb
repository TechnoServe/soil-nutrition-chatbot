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

ActiveRecord::Schema[8.0].define(version: 2025_03_10_061651) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "citext"
  enable_extension "pg_catalog.plpgsql"

  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
  end

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
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "api_tokens", force: :cascade do |t|
    t.string "token"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "cm_permissions", force: :cascade do |t|
    t.string "action_name"
    t.string "action_display_name"
    t.string "ar_model_name"
    t.string "scope_name"
    t.bigint "cm_role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cm_role_id"], name: "index_cm_permissions_on_cm_role_id"
  end

  create_table "cm_roles", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "default_redirect_path", default: "/cm_admin/users"
  end

  create_table "constant_translations", force: :cascade do |t|
    t.bigint "constant_id", null: false
    t.string "locale", null: false
    t.citext "name"
    t.jsonb "meta", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["constant_id", "locale"], name: "index_constant_translations_on_constant_id_and_locale", unique: true
    t.index ["constant_id"], name: "index_constant_translations_on_constant_id"
  end

  create_table "constants", force: :cascade do |t|
    t.citext "name"
    t.integer "constant_type"
    t.bigint "parent_id"
    t.integer "position"
    t.jsonb "meta", default: {}
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "crop_nutrient_demands", force: :cascade do |t|
    t.bigint "crop_id"
    t.bigint "nutrient_id"
    t.decimal "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crop_id"], name: "index_crop_nutrient_demands_on_crop_id"
    t.index ["nutrient_id"], name: "index_crop_nutrient_demands_on_nutrient_id"
  end

  create_table "crop_nutrient_requirements", force: :cascade do |t|
    t.bigint "crop_id"
    t.bigint "nutrient_id"
    t.bigint "unit_id"
    t.decimal "stage1"
    t.decimal "stage2"
    t.decimal "stage3"
    t.decimal "stage4"
    t.decimal "stage5"
    t.decimal "stage6"
    t.decimal "requirement_per_ton"
    t.decimal "total_requirement"
    t.decimal "performance"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crop_id"], name: "index_crop_nutrient_requirements_on_crop_id"
    t.index ["nutrient_id"], name: "index_crop_nutrient_requirements_on_nutrient_id"
    t.index ["unit_id"], name: "index_crop_nutrient_requirements_on_unit_id"
  end

  create_table "crop_productions", force: :cascade do |t|
    t.bigint "crop_id"
    t.bigint "desired_productivity_id"
    t.decimal "productivity"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["crop_id"], name: "index_crop_productions_on_crop_id"
    t.index ["desired_productivity_id"], name: "index_crop_productions_on_desired_productivity_id"
  end

  create_table "file_exports", force: :cascade do |t|
    t.string "associated_model_name"
    t.string "exported_by_type", null: false
    t.bigint "exported_by_id", null: false
    t.datetime "expires_at"
    t.integer "status", default: 0
    t.jsonb "params", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["exported_by_type", "exported_by_id"], name: "index_file_exports_on_exported_by"
  end

  create_table "file_imports", force: :cascade do |t|
    t.string "associated_model_name"
    t.string "added_by_type", null: false
    t.bigint "added_by_id", null: false
    t.jsonb "error_report", default: {}
    t.datetime "completed_at"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["added_by_type", "added_by_id"], name: "index_file_imports_on_added_by"
  end

  create_table "inorganic_recommendation_rows", force: :cascade do |t|
    t.bigint "inorganic_recommendation_id"
    t.bigint "amendment_id"
    t.boolean "result"
    t.string "first_element_name"
    t.string "second_element_name"
    t.string "first_element_amount"
    t.string "second_element_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["amendment_id"], name: "index_inorganic_recommendation_rows_on_amendment_id"
    t.index ["inorganic_recommendation_id"], name: "idx_on_inorganic_recommendation_id_2e5e3c7652"
  end

  create_table "inorganic_recommendations", force: :cascade do |t|
    t.bigint "soil_evaluation_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soil_evaluation_request_id"], name: "index_inorganic_recommendations_on_soil_evaluation_request_id"
  end

  create_table "organic_recommendations", force: :cascade do |t|
    t.bigint "soil_evaluation_request_id"
    t.decimal "amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soil_evaluation_request_id"], name: "index_organic_recommendations_on_soil_evaluation_request_id"
  end

  create_table "otp_requests", force: :cascade do |t|
    t.string "otp"
    t.datetime "expired_at"
    t.integer "status"
    t.datetime "verified_at"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_otp_requests_on_user_id"
  end

  create_table "soil_evaluation_nutrient_results", force: :cascade do |t|
    t.bigint "soil_evaluation_result_id"
    t.string "index_field"
    t.decimal "n_amount"
    t.decimal "p2o5_amount"
    t.decimal "k2o_amount"
    t.decimal "cao_amount"
    t.decimal "mgo_amount"
    t.decimal "s_amount"
    t.decimal "fe_amount"
    t.decimal "zn_amount"
    t.decimal "mn_amount"
    t.decimal "cu_amount"
    t.decimal "b_amount"
    t.integer "result_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soil_evaluation_result_id"], name: "idx_on_soil_evaluation_result_id_49c37332f8"
  end

  create_table "soil_evaluation_requests", force: :cascade do |t|
    t.bigint "creator_id"
    t.bigint "crop_id"
    t.bigint "state_id"
    t.bigint "desired_productivity_id"
    t.bigint "organic_matter_id"
    t.string "producer_name"
    t.string "parcel_name"
    t.boolean "fertigation"
    t.decimal "ph"
    t.decimal "electrical_conductivity"
    t.decimal "organic_matter_value"
    t.decimal "sampling_depth"
    t.string "texture"
    t.decimal "apparent_density"
    t.decimal "nitrogen_ppm"
    t.decimal "phosphorus_ppm"
    t.decimal "potassium_ppm"
    t.decimal "calcium_ppm"
    t.decimal "magnesium_ppm"
    t.decimal "sulfur_ppm"
    t.decimal "iron_ppm"
    t.decimal "copper_ppm"
    t.decimal "manganese_ppm"
    t.decimal "zinc_ppm"
    t.decimal "boron_ppm"
    t.decimal "cation_exchange_capacity"
    t.decimal "calcium_percentage"
    t.decimal "magnesium_percentage"
    t.decimal "potassium_percentage"
    t.decimal "sodium_percentage"
    t.decimal "hydrogen_percentage"
    t.decimal "aluminum_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "age_range_id"
    t.bigint "gender_id"
    t.index ["age_range_id"], name: "index_soil_evaluation_requests_on_age_range_id"
    t.index ["creator_id"], name: "index_soil_evaluation_requests_on_creator_id"
    t.index ["crop_id"], name: "index_soil_evaluation_requests_on_crop_id"
    t.index ["desired_productivity_id"], name: "index_soil_evaluation_requests_on_desired_productivity_id"
    t.index ["gender_id"], name: "index_soil_evaluation_requests_on_gender_id"
    t.index ["organic_matter_id"], name: "index_soil_evaluation_requests_on_organic_matter_id"
    t.index ["state_id"], name: "index_soil_evaluation_requests_on_state_id"
  end

  create_table "soil_evaluation_results", force: :cascade do |t|
    t.bigint "soil_evaluation_request_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["soil_evaluation_request_id"], name: "index_soil_evaluation_results_on_soil_evaluation_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.bigint "cm_role_id"
    t.index ["cm_role_id"], name: "index_users_on_cm_role_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object"
    t.datetime "created_at"
    t.text "object_changes"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "api_tokens", "users"
  add_foreign_key "cm_permissions", "cm_roles"
  add_foreign_key "constant_translations", "constants"
  add_foreign_key "crop_nutrient_demands", "constants", column: "crop_id"
  add_foreign_key "crop_nutrient_demands", "constants", column: "nutrient_id"
  add_foreign_key "crop_nutrient_requirements", "constants", column: "crop_id"
  add_foreign_key "crop_nutrient_requirements", "constants", column: "nutrient_id"
  add_foreign_key "crop_nutrient_requirements", "constants", column: "unit_id"
  add_foreign_key "crop_productions", "constants", column: "crop_id"
  add_foreign_key "crop_productions", "constants", column: "desired_productivity_id"
  add_foreign_key "inorganic_recommendation_rows", "constants", column: "amendment_id"
  add_foreign_key "otp_requests", "users"
  add_foreign_key "soil_evaluation_requests", "constants", column: "age_range_id"
  add_foreign_key "soil_evaluation_requests", "constants", column: "crop_id"
  add_foreign_key "soil_evaluation_requests", "constants", column: "desired_productivity_id"
  add_foreign_key "soil_evaluation_requests", "constants", column: "gender_id"
  add_foreign_key "soil_evaluation_requests", "constants", column: "organic_matter_id"
  add_foreign_key "soil_evaluation_requests", "constants", column: "state_id"
  add_foreign_key "soil_evaluation_requests", "users", column: "creator_id"
  add_foreign_key "users", "cm_roles"
end
