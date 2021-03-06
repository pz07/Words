# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100504092929) do

  create_table "answer", :force => true do |t|
    t.integer  "question_id",                :null => false
    t.text     "text",                       :null => false
    t.integer  "priority",    :default => 1, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tip"
  end

  create_table "iteration", :force => true do |t|
    t.integer  "question_id",                      :null => false
    t.integer  "iteration",                        :null => false
    t.float    "day_interval"
    t.datetime "learning_begin",                   :null => false
    t.datetime "learning_finished"
    t.integer  "answers_0",         :default => 0, :null => false
    t.integer  "answers_1",         :default => 0, :null => false
    t.integer  "answers_2",         :default => 0, :null => false
    t.integer  "answers_3",         :default => 0, :null => false
    t.integer  "answers_4",         :default => 0, :null => false
    t.integer  "answers_5",         :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "learning_schema", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "lesson", :force => true do |t|
    t.string   "name",                          :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                       :null => false
    t.boolean  "active",      :default => true, :null => false
  end

  create_table "level", :force => true do |t|
    t.integer  "learning_schema_id"
    t.integer  "level"
    t.integer  "day_interval"
    t.string   "color"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "question", :force => true do |t|
    t.integer  "lesson_id",                                            :null => false
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "last_attempt_date"
    t.boolean  "active",            :default => true,                  :null => false
    t.datetime "next_attempt_date", :default => '2010-01-20 14:19:48', :null => false
    t.string   "question_tip"
    t.string   "answer_tip"
    t.float    "e_factor",          :default => 2.5,                   :null => false
    t.integer  "iteration",         :default => 1,                     :null => false
  end

  create_table "question_level_stat", :force => true do |t|
    t.integer  "question_id",                      :null => false
    t.integer  "level_id",                         :null => false
    t.datetime "learning_begin",                   :null => false
    t.datetime "learning_finished"
    t.integer  "correct_answers",   :default => 0, :null => false
    t.integer  "wrong_answers",     :default => 0, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "repetition", :force => true do |t|
    t.integer  "question_id", :null => false
    t.integer  "user_id",     :null => false
    t.datetime "day",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "session", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "session", ["session_id"], :name => "index_session_on_session_id"
  add_index "session", ["updated_at"], :name => "index_session_on_updated_at"

  create_table "user", :force => true do |t|
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",              :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :null => false
    t.string   "crypted_password",                      :null => false
    t.string   "password_salt",                         :null => false
    t.string   "persistence_token",                     :null => false
    t.string   "perishable_token",                      :null => false
    t.integer  "login_count",        :default => 0,     :null => false
    t.integer  "failed_login_count", :default => 0,     :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.boolean  "admin",              :default => false, :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
