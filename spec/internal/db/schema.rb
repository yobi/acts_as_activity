ActiveRecord::Schema.define version: 0 do
  create_table "contestants", :force => true do |t|
    t.string   "title",      :null => false
    t.integer  "contest_id", :null => false
    t.integer  "user_id",    :null => false
    t.datetime "created",    :null => false
    t.datetime "modified",   :null => false
    t.boolean  "active",     :null => false
    t.boolean  "published",  :null => false
    t.boolean  "processed",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                 :limit => 100,                    :null => false
    t.string   "screenname",            :limit => 32,                     :null => false
  end

  create_table "contests", :force => true do |t|
    t.string "name", :null => false
  end
end
