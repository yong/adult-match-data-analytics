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

ActiveRecord::Schema.define(version: 20171207222113) do

  create_table "arms", id: :integer, force: :cascade do |t|
    t.integer "patient_scenerio_id", null: false
    t.string "arm", limit: 256, null: false
    t.string "selection_type", limit: 256, default: "POTENTIAL", null: false
  end

  create_table "exclusion_scenerios", id: :integer, force: :cascade do |t|
    t.string "description", limit: 256
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "inclusion_scenerios", id: :integer, force: :cascade do |t|
    t.string "description", limit: 256
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patient_scenerios", id: :integer, force: :cascade do |t|
    t.integer "patients_id", null: false
    t.integer "inclusion_scenerio_id", null: false
    t.integer "exclusion_scenerio_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "patients", id: :integer, force: :cascade do |t|
    t.string "vcf_version", limit: 256
    t.string "sequencing_date", limit: 256
    t.string "disease", limit: 256
    t.string "meddra_code", limit: 256
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
