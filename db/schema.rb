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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180814073045) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "fuzzystrmatch"
  enable_extension "pg_trgm"

  create_table "categories", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.text     "keywords"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.string   "hash_tag"
  end

  create_table "categories_news_items", id: false, force: :cascade do |t|
    t.integer "category_id"
    t.integer "news_item_id"
  end

  add_index "categories_news_items", ["category_id", "news_item_id"], name: "categories_news_items_index", unique: true, using: :btree

  create_table "impressions", force: :cascade do |t|
    t.string   "impressionable_type"
    t.integer  "impressionable_id"
    t.integer  "user_id"
    t.string   "controller_name"
    t.string   "action_name"
    t.string   "view_name"
    t.string   "request_hash"
    t.string   "ip_address"
    t.string   "session_hash"
    t.text     "message"
    t.text     "referrer"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "impressions", ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index", using: :btree
  add_index "impressions", ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index", using: :btree
  add_index "impressions", ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index", using: :btree
  add_index "impressions", ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", using: :btree
  add_index "impressions", ["user_id"], name: "index_impressions_on_user_id", using: :btree

  create_table "linkages", force: :cascade do |t|
    t.integer  "from_id"
    t.integer  "to_id"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
    t.boolean  "different",  default: false
  end

  add_index "linkages", ["from_id"], name: "index_linkages_on_from_id", using: :btree
  add_index "linkages", ["to_id"], name: "index_linkages_on_to_id", using: :btree

  create_table "mail_subscription_histories", force: :cascade do |t|
    t.integer  "mail_subscription_id"
    t.integer  "news_items_in_mail"
    t.datetime "opened_at"
    t.string   "open_token"
    t.integer  "click_count",          default: 0
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "mail_subscription_histories", ["mail_subscription_id"], name: "index_mail_subscription_histories_on_mail_subscription_id", using: :btree

  create_table "mail_subscriptions", force: :cascade do |t|
    t.text     "email"
    t.json     "preferences"
    t.string   "token"
    t.datetime "last_send_date"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.integer  "limit"
    t.integer  "gender"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "academic_title"
    t.string   "company"
    t.string   "position"
    t.boolean  "extended_member", default: false
    t.datetime "deleted_at"
    t.integer  "status",          default: 0
  end

  add_index "mail_subscriptions", ["token"], name: "index_mail_subscriptions_on_token", unique: true, using: :btree

  create_table "news_items", force: :cascade do |t|
    t.string   "title",                       limit: 255
    t.text     "teaser"
    t.string   "url",                         limit: 255
    t.integer  "source_id"
    t.datetime "published_at"
    t.integer  "value"
    t.integer  "fb_likes"
    t.integer  "retweets"
    t.string   "guid",                        limit: 255
    t.integer  "linkedin"
    t.integer  "xing"
    t.datetime "created_at",                                              null: false
    t.datetime "updated_at",                                              null: false
    t.integer  "gplus"
    t.text     "full_text"
    t.integer  "word_length"
    t.text     "plaintext"
    t.tsvector "search_vector"
    t.integer  "incoming_link_count"
    t.float    "absolute_score"
    t.boolean  "blacklisted",                             default: false
    t.integer  "reddit"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.integer  "impression_count",                        default: 0
    t.string   "tweet_id"
    t.integer  "absolute_score_per_halflife"
  end

  add_index "news_items", ["absolute_score", "published_at"], name: "index_news_items_on_absolute_score_and_published_at", using: :btree
  add_index "news_items", ["absolute_score"], name: "index_news_items_on_absolute_score", using: :btree
  add_index "news_items", ["guid"], name: "index_news_items_on_guid", using: :btree
  add_index "news_items", ["published_at"], name: "index_news_items_on_published_at", using: :btree
  add_index "news_items", ["search_vector"], name: "index_news_items_on_search_vector", using: :gin
  add_index "news_items", ["source_id"], name: "index_news_items_on_source_id", using: :btree
  add_index "news_items", ["value"], name: "index_news_items_on_value", using: :btree

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.text   "value"
  end

  add_index "settings", ["key"], name: "index_settings_on_key", unique: true, using: :btree

  create_table "sources", force: :cascade do |t|
    t.string   "type",                          limit: 255
    t.string   "url",                           limit: 255
    t.string   "name",                          limit: 255
    t.integer  "value"
    t.datetime "created_at",                                                null: false
    t.datetime "updated_at",                                                null: false
    t.string   "logo_file_name",                limit: 255
    t.string   "logo_content_type",             limit: 255
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.string   "full_text_selector",            limit: 255
    t.boolean  "error"
    t.float    "multiplicator",                             default: 1.0
    t.boolean  "lsr_active",                                default: false
    t.boolean  "deactivated",                               default: false
    t.integer  "default_category_id"
    t.string   "lsr_confirmation_file_name"
    t.string   "lsr_confirmation_content_type"
    t.integer  "lsr_confirmation_file_size"
    t.datetime "lsr_confirmation_updated_at"
    t.string   "twitter_account"
    t.string   "language"
    t.text     "comment"
    t.text     "filter_rules"
    t.json     "statistics"
  end

  add_index "sources", ["type"], name: "index_sources_on_type", using: :btree

  create_table "trends_usages", force: :cascade do |t|
    t.integer "word_id"
    t.integer "news_item_id"
    t.integer "source_id"
    t.string  "calendar_week"
  end

  add_index "trends_usages", ["news_item_id"], name: "index_trends_usages_on_news_item_id", using: :btree
  add_index "trends_usages", ["source_id"], name: "index_trends_usages_on_source_id", using: :btree
  add_index "trends_usages", ["word_id"], name: "index_trends_usages_on_word_id", using: :btree

  create_table "trends_words", force: :cascade do |t|
    t.string   "word"
    t.integer  "parent_id"
    t.boolean  "ignore"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "mail_subscription_histories", "mail_subscriptions"
  add_foreign_key "trends_usages", "news_items"
  add_foreign_key "trends_usages", "sources"
end
