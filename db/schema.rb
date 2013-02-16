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

ActiveRecord::Schema.define(:version => 20121203064953) do

  create_table "chats", :force => true do |t|
    t.string   "message"
    t.integer  "receiver_id"
    t.integer  "user_id"
    t.integer  "room_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "connections", :force => true do |t|
    t.integer  "user_id"
    t.integer  "room_id"
    t.string   "user_status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "connections", ["room_id"], :name => "index_connections_on_room_id"
  add_index "connections", ["user_id"], :name => "index_connections_on_user_id"

  create_table "game_histories", :force => true do |t|
    t.integer  "room_id"
    t.integer  "turn_no"
    t.integer  "attacker_id"
    t.integer  "target_id"
    t.integer  "coordinate_x"
    t.integer  "coordinate_y"
    t.string   "status"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "grids", :force => true do |t|
    t.integer  "user_id"
    t.integer  "ship_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.string   "alignment"
    t.integer  "ship_size"
    t.integer  "coordinate_x"
    t.integer  "coordinate_y"
    t.integer  "current_coordinate_x"
    t.integer  "current_coordinate_y"
    t.integer  "room_id"
    t.string   "status"
    t.integer  "shooter_id"
    t.string   "grid_type"
  end

  add_index "grids", ["coordinate_x"], :name => "index_grids_on_coordinate_x"
  add_index "grids", ["coordinate_y"], :name => "index_grids_on_coordinate_y"
  add_index "grids", ["grid_type"], :name => "index_grids_on_grid_type"
  add_index "grids", ["room_id"], :name => "index_grids_on_room_id"
  add_index "grids", ["status"], :name => "index_grids_on_status"
  add_index "grids", ["user_id"], :name => "index_grids_on_user_id"

  create_table "rooms", :force => true do |t|
    t.integer  "max_user"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "name"
    t.string   "host_id"
    t.string   "status"
    t.integer  "users_turn"
    t.integer  "first_player"
    t.integer  "current_player"
    t.integer  "winner"
    t.integer  "occupancy"
    t.integer  "turn_no"
    t.integer  "salvo"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "password_digest"
    t.string   "remember_token"
  end

  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

end
