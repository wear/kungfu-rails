require 'fastercsv'

namespace :csv do
  desc "import all attendees to attendees.csv"
  task :generate => :environment do
    FasterCSV.open("./attendee.csv", 'w') do |csv|
      csv << ['Name', 'Email', 'Phone number', 'Company', 'Title', 'Company Category', 'Company size', 'Industry', 'Work Experience', 'Ruby Experience', 'City', 'State', 'Country', 'Website', 'Interesting', 'Introduction']
      Attendee.all.each do |a|
        csv << [a.name, a.email, a.phone_number, a.company, a.title, a.company_category, a.company_size, a.industry, a.work_experience, a.ruby_experience, a.city, a.state, a.country, a.website, a.interesting, a.description]
     end
    end
  end
end
