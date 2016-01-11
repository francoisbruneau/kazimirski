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

admin = User.new(:email => 'admin@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('admin'), :confirmed_at => DateTime.now)
admin.save(validate: false)

reviewer = User.new(:email => 'reviewer@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('reviewer'), :confirmed_at => DateTime.now)
reviewer.save(validate: false)

transcriber = User.new(:email => 'transcriber@kazimirski.fr', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('transcriber'), :confirmed_at => DateTime.now)
transcriber.save(validate: false)

# Tome Premier
(1..1392).each do |source_page_nr|
  p = Page.new
  p.source_page_nr = source_page_nr
  p.book_nr = 1
  p.save
end

# Tome Second
(1..1638).each do |source_page_nr|
  p = Page.new
  p.source_page_nr = source_page_nr
  p.book_nr = 2
  p.save
end
