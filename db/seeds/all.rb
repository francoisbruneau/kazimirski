# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

['transcriber', 'reviewer', 'admin'].each do |role|
  Role.find_or_create_by({name: role})
end

User.create(:email => 'admin@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('admin'), :confirmed_at => DateTime.now)
User.create(:email => 'reviewer@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('reviewer'), :confirmed_at => DateTime.now)
User.create(:email => 'transcriber@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('transcriber'), :confirmed_at => DateTime.now)

# Create sample pages from sample scans
Dir.glob(Rails.root.join('public', 'scans', '*')).each do |filepath|
  p = Page.new
  p.scanned_image = File.open(filepath)
  captures = filepath.match(/t(\d+)p(\d+).png/).captures
  p.book_nr = captures.first.to_i
  p.source_page_nr = captures.second.to_i
  p.save
end
