# No need to generate text part as Mandrill apparently takes care of it
Premailer::Rails.config.merge!(generate_text_part: false)
