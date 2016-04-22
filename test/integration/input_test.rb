require 'test_helper'

# Ensure that BiDi specificities of the dictionary are properly handled during text input

class InputTest < ActionDispatch::IntegrationTest
  test "Commas and dashes are automatically prefixed with a left-to-right mark" do
    open_transcription_interface

    # When user types a comma or a dash in between arabic words, a left-to-right mark should be inserted immediately before it
    # So that synonyms or different meanings are shown in the left-to-right order.
    # This is necessary since commas and dashes are BiDi-neutral.

    element = find('trix-editor')

    words = arabic_lorem_words

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

    click_on 'commit'

    saved_page = Page.order(updated_at: :desc).first
    saved_char_codes = saved_page.content.chars.map{|c| c.ord}

    assert saved_char_codes == expected_char_codes
  end

  test "Numbers are automatically prefixed with a left-to-right mark" do
    open_transcription_interface

    element = find('trix-editor')
    words = arabic_lorem_words

    for i in 0..9
      element.native.send_key("#{i}")
      element.native.send_key(words[i])
    end

    val = element.value
    val.gsub!('<div>', '').gsub!('</div>', '')
    char_codes = val.chars.map{|c| c.ord}

    expected_char_codes = []

    for i in 0..9
      expected_char_codes += [0x200E]
      expected_char_codes += ["#{i}".ord]
      expected_char_codes += words[i].chars.map{|c| c.ord}
    end

    assert char_codes == expected_char_codes

    click_on 'commit'

    saved_page = Page.order(updated_at: :desc).first
    saved_char_codes = saved_page.content.chars.map{|c| c.ord}

    assert saved_char_codes == expected_char_codes
  end

end