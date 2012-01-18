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

ActiveRecord::Schema.define(:version => 20111208213423) do

  create_table "grupos", :force => true do |t|
    t.string   "nombre"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "grupos_usuarios", :id => false, :force => true do |t|
    t.integer "grupo_id"
    t.integer "usuario_id"
  end

  create_table "intereses", :force => true do |t|
    t.string   "nombre"
    t.integer  "facebook_id", :limit => 8
    t.string   "categoria"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "intereses_usuarios", :id => false, :force => true do |t|
    t.integer "interes_id"
    t.integer "usuario_id"
  end

  add_index "intereses_usuarios", ["interes_id", "usuario_id"], :name => "index_intereses_usuarios_on_interes_id_and_usuario_id", :unique => true

  create_table "invitaciones", :force => true do |t|
    t.boolean  "aceptada"
    t.integer  "usuario_desde_id"
    t.integer  "usuario_para_id"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "usuarios", :force => true do |t|
    t.integer  "facebook_id",       :limit => 8
    t.string   "genero"
    t.string   "email"
    t.string   "nombre"
    t.integer  "hora_lunch_inicio"
    t.integer  "hora_lunch_fin"
    t.string   "thumbnail"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "zonas", :force => true do |t|
    t.integer  "usuario_id"
    t.string   "nombre"
    t.float    "longitude"
    t.float    "latitude"
    t.float    "radio"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
