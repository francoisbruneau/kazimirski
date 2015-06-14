User.create(:email => 'admin@kazimirski.lo', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('admin'), :confirmed_at => DateTime.now)
User.create(:email => 'reviewer@kazimirski.lo', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('reviewer'), :confirmed_at => DateTime.now)
User.create(:email => 'transcriber@kazimirski.lo', :password => 'password', :password_confirmation => 'password', :role => Role.find_by_name('transcriber'), :confirmed_at => DateTime.now)

# Create sample pages from sample scans
Dir.glob(Rails.root.join('public', 'scans', '*')).each do |filepath|
  p = Page.new
  p.scanned_image = File.open(filepath)
  captures = filepath.match(/t(\d+)p(\d+).png/).captures
  p.book_nr = captures.first.to_i
  p.source_page_nr = captures.second.to_i
  p.save
end
