# Loads seed according to the current env.
# More info on: http://dennisreimann.de/blog/seeds-for-different-environments/
['all', Rails.env].each do |seed|
  seed_file = "#{Rails.root}/db/seeds/#{seed}.rb"
  if File.exists?(seed_file)
    puts "*** Loading #{seed} seed data"
    require seed_file
  end
end