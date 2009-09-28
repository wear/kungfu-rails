class Attendee < ActiveRecord::Base
  validates_presence_of :name, :email, :city, :state, :country, :company, :title,
                          :company_category, :company_size, :industry, :work_experience,
                          :ruby_experience, :phone_number

  COMPANY_CATEGORIES = ['foreign_company', 'private_company', 'state_owned_company']
  COMPANY_SIZES      = ['< 10', '10 - 50', '50 - 100', '100 - 500', '> 500']
  TITLES             = ['CTO', 'project_manager', 'architect', 'senior_engineer', 'engineer', 'student']
  INDUSTRIES         = ['web', 'profession_software', 'erp', 'game_development', 'media', 'e_commerce', 'other']
  WORK_EXPERIENCES   = ['< 1 year', '1-3 years', '3-5 years', '5-10 years', '> 10 years']
  RUBY_EXPERIENCES   = ['< 1 year', '1-3 years', '> 3 years']
                                                    
  validates_presence_of     :name

  validates_presence_of     :email
  validates_length_of       :email,    :within => 6..100 #r@a.wk
  validates_uniqueness_of   :email     

  protected
    def make_activation_code
        self.activation_code = self.class.make_token
    end
    
end
