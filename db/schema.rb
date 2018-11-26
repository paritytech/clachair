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

ActiveRecord::Schema.define(version: 2018_11_23_122108) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cla_signatures", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "cla_id"
    t.bigint "cla_version_id"
    t.bigint "repository_id"
    t.string "real_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cla_id"], name: "index_cla_signatures_on_cla_id"
    t.index ["cla_version_id"], name: "index_cla_signatures_on_cla_version_id"
    t.index ["repository_id"], name: "index_cla_signatures_on_repository_id"
    t.index ["user_id"], name: "index_cla_signatures_on_user_id"
  end

  create_table "cla_versions", force: :cascade do |t|
    t.text "license_text"
    t.bigint "cla_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cla_id"], name: "index_cla_versions_on_cla_id"
  end

  create_table "clas", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "uid"
    t.string "login"
    t.string "name"
    t.string "github_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["uid", "login"], name: "index_organizations_on_uid_and_login", unique: true
  end

  create_table "repositories", force: :cascade do |t|
    t.bigint "organization_id"
    t.string "uid"
    t.string "name"
    t.string "github_url"
    t.string "desc"
    t.string "license_name"
    t.string "license_spdx_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cla_id"
    t.index ["cla_id"], name: "index_repositories_on_cla_id"
    t.index ["license_spdx_id"], name: "index_repositories_on_license_spdx_id"
    t.index ["organization_id", "uid"], name: "index_repositories_on_organization_id_and_uid", unique: true
    t.index ["organization_id"], name: "index_repositories_on_organization_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "provider"
    t.string "uid"
    t.string "login"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "token"
    t.integer "role"
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "cla_signatures", "cla_versions"
  add_foreign_key "cla_signatures", "clas"
  add_foreign_key "cla_signatures", "repositories"
  add_foreign_key "cla_signatures", "users"
  add_foreign_key "cla_versions", "clas"
  add_foreign_key "repositories", "clas"
end
