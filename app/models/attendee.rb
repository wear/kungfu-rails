# == Schema Information
# Schema version: 20090420130416
#
# Table name: attendees
#
#  id               :integer         not null, primary key
#  name             :string(255)
#  email            :string(255)
#  website          :string(255)
#  company          :string(255)
#  phone_number     :string(255)
#  city             :string(255)
#  state            :string(255)
#  country          :string(255)
#  created_at       :datetime
#  updated_at       :datetime
#  description      :text
#  company_category :string(255)
#  industry         :string(255)
#  company_size     :string(255)
#  title            :string(255)
#  work_experience  :string(255)
#  ruby_experience  :string(255)
#  interesting      :string(255)
#  generated_at     :datetime
#  paid             :boolean
#

class Attendee < ActiveRecord::Base
  validates_presence_of :name, :email, :city, :state, :country, :company, :title,
                          :company_category, :company_size, :industry, :work_experience,
                          :ruby_experience, :phone_number
  has_one :payment, :class_name => "Payment", :foreign_key => "attendee_id", :dependent => :destroy 

  COMPANY_CATEGORIES = ['foreign_company', 'private_company', 'state_owned_company']
  COMPANY_SIZES      = ['< 10', '10 - 50', '50 - 100', '100 - 500', '> 500']
  TITLES             = ['CTO', 'project_manager', 'architect', 'senior_engineer', 'engineer', 'student']
  INDUSTRIES         = ['web', 'profession_software', 'erp', 'game_development', 'media', 'e_commerce', 'other']
  WORK_EXPERIENCES   = ['< 1 year', '1-3 years', '3-5 years', '5-10 years', '> 10 years']
  RUBY_EXPERIENCES   = ['< 1 year', '1-3 years', '> 3 years']
                                                    
  validates_presence_of     :name          
  validates_uniqueness_of   :name
  validates_length_of       :name,    :within => 2..40
  
  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk   
  validates_uniqueness_of   :email
  
  before_create :make_slug_url       
  
  named_scope :all_paided,:conditions => ['paid = ?',true]
  named_scope :all_join_party,:conditions => ['join_party = ?',true] 

  def to_param  # overridden
    slug_url
  end

 # protected  
 
    def self.generate_slug(length=6)
    charactars = ("a".."z").to_a + ("1".."9").to_a
    (0..length).inject([]) { |password, i| password << charactars[rand(charactars.size-1)] }.join
    end
    
    def make_slug_url
       self.slug_url = self.class.generate_slug(8) 
    end
    
end
