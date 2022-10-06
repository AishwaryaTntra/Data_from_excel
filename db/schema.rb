# frozen_string_literal: true

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

ActiveRecord::Schema[7.0].define(version: 20_220_928_095_731) do
  # These are extensions that must be enabled in order to support this database
  enable_extension 'plpgsql'

  create_table 'cities', force: :cascade do |t|
    t.string 'name'
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['user_id'], name: 'index_cities_on_user_id'
  end

  create_table 'customers', force: :cascade do |t|
    t.string 'name'
    t.string 'phone'
    t.string 'email'
    t.bigint 'location_id', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['location_id'], name: 'index_customers_on_location_id'
    t.index ['user_id'], name: 'index_customers_on_user_id'
  end

  create_table 'locations', force: :cascade do |t|
    t.string 'name'
    t.bigint 'city_id', null: false
    t.bigint 'user_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['city_id'], name: 'index_locations_on_city_id'
    t.index ['user_id'], name: 'index_locations_on_user_id'
  end

  create_table 'messages', force: :cascade do |t|
    t.string 'title'
    t.string 'body'
    t.bigint 'location_id', null: false
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.index ['location_id'], name: 'index_messages_on_location_id'
  end

  create_table 'roles', force: :cascade do |t|
    t.string 'name'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
  end

  create_table 'users', force: :cascade do |t|
    t.string 'name'
    t.string 'email'
    t.string 'phone'
    t.datetime 'created_at', null: false
    t.datetime 'updated_at', null: false
    t.bigint 'role_id'
    t.string 'encrypted_password', null: false
    t.string 'reset_password_token'
    t.datetime 'reset_password_sent_at'
    t.datetime 'remember_created_at'
    t.index ['email'], name: 'index_users_on_email', unique: true
    t.index ['reset_password_token'], name: 'index_users_on_reset_password_token', unique: true
    t.index ['role_id'], name: 'index_users_on_role_id'
  end

  add_foreign_key 'cities', 'users'
  add_foreign_key 'customers', 'locations'
  add_foreign_key 'customers', 'users'
  add_foreign_key 'locations', 'cities'
  add_foreign_key 'locations', 'users'
  add_foreign_key 'messages', 'locations'
  add_foreign_key 'users', 'roles'
end
