ActiveRecord::Schema.define(:version => 20090420130416) do
  create_table "attendees", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "website"
    t.string   "company"
    t.string   "phone_number"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "company_category"
    t.string   "industry"
    t.string   "company_size"
    t.string   "title"
    t.string   "work_experience"
    t.string   "ruby_experience"
    t.string   "interesting"
    t.boolean  "need_invoice"
    t.string   "invoice_header"
    t.string   "invoice_address"
    t.boolean  "join_party"
    t.datetime "generated_at" 
    t.string   "slug_url"
    t.boolean  "paid", :default => false
  end 
  
  create_table "payments", :force => true do |t|   
    t.integer  "attendee_id"     
    t.integer "paid_count"
    t.string  "description"
    t.text  "payment_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end
  
  create_table "roles", :force => true do |t|
    t.string "title"
  end

  create_table "roles_users", :id => false, :force => true do |t|
    t.integer "role_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
end