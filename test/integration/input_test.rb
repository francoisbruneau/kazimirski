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

  test "Text style is automatically reset when starting a new paragraph" do
    # TODO This one is tricky to make, due to Trix's deactivateAttribute("italic") apparently not working in PhantomJS
    # ...
    # The italic style is mysteriously disabled when PhantomJS sends more than one key event at once
    # ...
    # Skipping it for now
    return


    open_transcription_interface

    element = find('trix-editor')
    element.native.send_key('Starting a sentence in normal text ')

    # switch to italic
    click_button 'Italic'

    page.save_screenshot("/vagrant/page.png", :full => true)

    # Sort of a hack. If sending all keys at once, the italic style is disabled before the first character.
    element.native.send_key('c')
    element.native.send_key('ontinuing it in italic.')

    page.save_screenshot("/vagrant/page2.png", :full => true)
    sleep 1

    element.native.send_key(:Enter)
    page.save_screenshot("/vagrant/page3.png", :full => true)

    sleep 1
    page.save_screenshot("/vagrant/page4.png", :full => true)

    element.native.send_key('A')
    page.save_screenshot("/vagrant/page5.png", :full => true)

    #element.native.send_key('fter a carriage return, the text should be normal again.')

    val = element.value
    p val
  end

  test "Normal dashes are replaced by long ones (em dashes 0x2014) after the auto-correct delay" do
    open_transcription_interface
    element = find('trix-editor')

    element.native.send_key('One ', '-', ' two ', '-', ' three.')

    sleep 0.25

    val = element.value
    val.gsub!('<div>', '').gsub!('</div>', '')
    char_codes = val.chars.map{|c| c.ord}

    # Dashes are automatically prefixed with a left-to-right mark (0x200E)
    expected_char_codes = 'One '.chars.map{|c| c.ord} + [0x200E] + [0x2014] + ' two '.chars.map{|c| c.ord} + [0x200E] + [0x2014] + ' three.'.chars.map{|c| c.ord}

    assert char_codes == expected_char_codes

    click_on 'commit'

    saved_page = Page.order(updated_at: :desc).first
    saved_char_codes = saved_page.content.chars.map{|c| c.ord}

    assert saved_char_codes == expected_char_codes
  end

  test "Normal spaces between arabic words are replaced by non-breaking ones after the auto-correct delay" do
    open_transcription_interface
    element = find('trix-editor')

    words = arabic_lorem_words
    element.native.send_key('Hello', :Space, words.first, :Space , words.second, :Space, words.third, :Space, 'Goodbye')

    sleep 0.25

    val = element.value
    val.gsub!('<div>', '').gsub!('</div>', '')
    char_codes = val.chars.map{|c| c.ord}

    # Each regular space between arabic words is replaced by three narrow non-break spaces
    expected_char_codes = 'Hello'.chars.map{|c| c.ord} \
                          + [0x0020] \
                          + words.first.chars.map{|c| c.ord} \
                          + [0x202F] \
                          + words.second.chars.map{|c| c.ord} \
                          + [0x202F] \
                          + words.third.chars.map{|c| c.ord} \
                          + [0x0020] \
                          + 'Goodbye'.chars.map{|c| c.ord}

    assert char_codes == expected_char_codes

    click_on 'commit'

    saved_page = Page.order(updated_at: :desc).first
    saved_char_codes = saved_page.content.chars.map{|c| c.ord}

    assert saved_char_codes == expected_char_codes
  end

  test "Italic style is automatically disabled when user starts to type an arabic word" do
    open_transcription_interface
    element = find('trix-editor')

    words = arabic_lorem_words

    click_button 'Italic'

    element.native.send_key('H')
    element.native.send_key(words.first.chars.first)

    val = element.value
    val.gsub!('<div>', '').gsub!('</div>', '')

    expected_val = '<em>H</em>' + words.first.chars.first

    assert val == expected_val

    click_on 'commit'

    saved_page = Page.order(updated_at: :desc).first
    saved_val = saved_page.content

    assert saved_val == expected_val
  end

end