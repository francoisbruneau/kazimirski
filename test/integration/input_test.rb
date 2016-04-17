require 'test_helper'

class InputTest < ActionDispatch::IntegrationTest
  test "BiDi specificities of the dictionary are properly handled during text input" do
    login_as_transcriber

    if page.has_selector?('#start-transcription')
      click_on 'start-transcription'
    else
      click_on 'resume-transcription'
    end

    if page.has_selector?('body.modal-open')
      click_button 'modal-dismiss'
    end

    # When user types a comma or a dash in between arabic words, a left-to-right mark should be inserted immediately before it
    # So that synonyms or different meanings are shown in the left-to-right order.
    # This is necessary since commas and dashes are BiDi-neutral.

    element = find('trix-editor')

    path = File.join(Rails.root, 'lib', 'assets', 'arabic-lorem.txt')
    text = File.read(path)
    words = text.split

    element.native.send_key(words.first)
    element.native.send_key(',')
    element.native.send_key(words.second)
    element.native.send_key('-')
    element.native.send_key(words.third)

    #The first 3 words of the arabic lorem ipsum should appear in reverse order because of the inserted control characters
    #page.save_screenshot("/vagrant/page3.png", :full => true)

    val = element.value
    val.gsub!('<div>', '').gsub!('</div>', '')

    char_codes = val.chars.map{|c| c.ord}
    expected_char_codes = words.first.chars.map{|c| c.ord} + [0x200E] + [','.ord] + words.second.chars.map{|c| c.ord} + [0x200E] + ['-'.ord] + words.third.chars.map{|c| c.ord}

    assert char_codes == expected_char_codes
  end
end