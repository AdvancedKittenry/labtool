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

ActiveRecord::Schema.define(:version => 20140408104328) do

  create_table "checklist_checks", :force => true do |t|
    t.text    "check"
    t.string  "varname"
    t.decimal "value",              :default => 0.0, :null => false
    t.integer "checklist_topic_id"
    t.integer "ordering"
    t.text    "feedback"
    t.text    "missing_feedback"
    t.decimal "unchecked_value",    :default => 0.0, :null => false
    t.integer "type_id"
  end

  create_table "checklist_topics", :force => true do |t|
    t.text    "title"
    t.string  "varname"
    t.integer "ordering"
    t.integer "checklist_id"
    t.integer "scoretype_id"
    t.text    "update_callback"
    t.text    "init_callback"
    t.decimal "score_target"
    t.integer "scale_denominator", :default => 1, :null => false
    t.integer "scale_numerator",   :default => 1, :null => false
  end

  create_table "checklist_topics_checks", :force => true do |t|
    t.integer "checklist_topic_id"
    t.integer "checklist_check_id"
    t.integer "ordering"
    t.decimal "value",              :default => 0.0, :null => false
    t.decimal "unchecked_value",    :default => 0.0, :null => false
  end

  create_table "checklists", :force => true do |t|
    t.string  "title"
    t.integer "ordering"
    t.integer "parent_id"
    t.text    "init_callback"
    t.text    "grade_callback"
    t.text    "remarks"
  end

  create_table "checktypes", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "courses", :force => true do |t|
    t.integer  "year"
    t.string   "period"
    t.boolean  "active"
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
    t.integer  "review_round"
    t.integer  "week"
    t.integer  "state"
    t.boolean  "mandatory_reviews"
    t.string   "name"
    t.integer  "week_feedback_max_points"
    t.boolean  "email_student"
    t.boolean  "email_instructor"
    t.integer  "weeks_total"
    t.integer  "reviews_total"
    t.integer  "default_checklist_id"
  end

  create_table "feedback_comments", :force => true do |t|
    t.text     "text"
    t.integer  "user_id"
    t.integer  "week_feedback_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "passed_checks", :force => true do |t|
    t.integer  "checklist_check_id"
    t.integer  "registration_id"
    t.boolean  "selected"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "peer_reviews", :force => true do |t|
    t.string   "notes"
    t.boolean  "done"
    t.integer  "reviewer_id"
    t.integer  "reviewed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "round"
  end

  create_table "registrations", :force => true do |t|
    t.string   "topic"
    t.string   "repository"
    t.integer  "user_id"
    t.integer  "course_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.boolean  "participate_review1"
    t.boolean  "participate_review2"
    t.boolean  "active"
    t.decimal  "review1"
    t.decimal  "review2"
    t.string   "test_url"
    t.integer  "grade"
    t.string   "language"
  end

  create_table "scoretypes", :force => true do |t|
    t.string  "name",                     :null => false
    t.string  "varname"
    t.decimal "initial", :default => 0.0, :null => false
    t.decimal "min",     :default => 0.0, :null => false
    t.decimal "max",     :default => 3.0, :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "forename"
    t.string   "surename"
    t.string   "student_number"
    t.string   "email"
    t.boolean  "admin"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.boolean  "hidden"
  end

  create_table "week_feedbacks", :force => true do |t|
    t.integer  "week"
    t.text     "text"
    t.integer  "registration_id"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.text     "hidden_text"
    t.decimal  "points"
    t.integer  "giver_id"
    t.boolean  "is_grade",        :default => false, :null => false
  end

end
