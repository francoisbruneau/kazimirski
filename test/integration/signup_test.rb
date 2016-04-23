require 'test_helper'

# NOTE: This test will fail if CAPTCHA_xxx environment variables are not set.

class SignupTest < ActionDispatch::IntegrationTest
  test "A user can signup, pass the captcha, confirm his acccount, login, and automatically get the Transcriber role" do
    visit root_path

    click_link 'Rejoindre le projet'

    captcha_uuid = find('input[name="captcha_uuid"]', :visible => :all).value

    # get the captcha UUID, get the proper answer from the ENV variable
    fill_in 'Captcha', with: ENV["CAPTCHA_#{captcha_uuid}"]

    email = "transcriberbot+#{SecureRandom.hex}@kazimirski.fr"
    fill_in 'Email', with: email

    password = SecureRandom.base64
    fill_in 'Mot de passe', with: password
    fill_in 'Confirmation du mot de passe', with: password
    click_button "S'inscrire"

    assert page.has_content?(I18n.t('devise.registrations.signed_up_but_unconfirmed')), 'Prompt to check inbox for confirmation email not shown.'


    confirmation_emails = ActionMailer::Base.deliveries.select{|d| d.subject == 'Instructions de confirmation'}
    assert confirmation_emails.length == 1

    confirmation_email = confirmation_emails.first
    to_field = confirmation_email.to.first

    assert to_field == email, 'Confirmation email was not sent.'

    body = confirmation_email.body.to_s
    token = /confirmation_token=(.){20}/.match(body).to_s
    token.sub!('confirmation_token=', '')

    visit user_confirmation_path(confirmation_token: token)
    assert page.has_content?(I18n.t('devise.confirmations.confirmed')), 'Confirmation notice was not shown.'



    fill_in 'Email', with: email
    fill_in 'Mot de passe', with: password
    click_button 'Se connecter'

    assert page.has_content?('Tableau de bord'), 'Dashboard not shown upon successful post-confirmation login.'


    assert User.last.is_transcriber?, 'User does not get Transcriber role upon sign-up.'

    #page.save_screenshot("/vagrant/page.png", :full => true)
  end
end