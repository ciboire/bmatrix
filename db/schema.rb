# encoding: UTF-8
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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120903145700) do

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.integer  "plan_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "plans", :force => true do |t|
    t.string   "target"
    t.string   "lastname"
    t.string   "firstname"
    t.string   "status",                   :default => "Upcoming"
    t.datetime "when_upcoming"
    t.datetime "when_needs_image_review"
    t.datetime "when_needs_setup"
    t.datetime "when_needs_preparation"
    t.datetime "when_needs_md_contours"
    t.datetime "when_needs_plan"
    t.datetime "when_needs_approval"
    t.datetime "when_needs_finalizing"
    t.datetime "when_ready_for_treatment"
    t.datetime "when_in_treatment"
    t.datetime "when_finished_treatment"
    t.boolean  "is_active",                :default => true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "when_waiting_for_consult"
    t.string   "attending_md"
    t.string   "notes"
    t.string   "modality"
  end

end
