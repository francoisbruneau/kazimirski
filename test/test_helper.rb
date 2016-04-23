require 'simplecov'
SimpleCov.start
if ENV['CI']=='true'
  require 'codecov'
  SimpleCov.formatter = SimpleCov::Formatter::Codecov
end

ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require "capybara/rails"
require 'capybara/poltergeist'

Capybara.default_wait_time = 15

Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {js_errors: false, timeout: 15})
end

Capybara.default_driver =:poltergeist

# Uncomment to rebuild the test DB every time the tests are launched
#Rake::Task["db:reset"].invoke
#load "#{Rails.root}/db/seeds.rb"

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  # fixtures :all

  def login_as_transcriber
    visit root_path

    click_link 'Connexion'

    fill_in 'Email', with: 'transcriber@kazimirski.fr'
    fill_in 'Mot de passe', with: 'password'
    click_button 'Se connecter'
  end

  def open_transcription_interface
    login_as_transcriber

    if page.has_selector?('#start-transcription')
      click_on 'start-transcription'
    else
      click_on 'resume-transcription'
    end

    if page.has_selector?('body.modal-open')
      click_button 'modal-dismiss'
    end
  end

  def arabic_lorem_words
    path = File.join(Rails.root, 'lib', 'assets', 'arabic-lorem.txt')
    text = File.read(path)
    text.split
  end

  # Add more helper methods to be used by all tests here...
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end