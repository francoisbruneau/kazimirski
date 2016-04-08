require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  test "login and browse site" do
    visit root_path

    click_link 'Connexion'

    fill_in 'Email', with: 'transcriber@kazimirski.fr'
    fill_in 'Mot de passe', with: 'password'
    click_button 'Se connecter'

    assert page.has_content?('Tableau de bord'), 'Dashboard not shown upon successful login.'

    #page.save_screenshot("/vagrant/page.png", :full => true)
  end
end