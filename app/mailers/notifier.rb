class Notifier < ApplicationMailer

  def new_sign_up(email, time)
    @email = email
    @time = time
    mail(to: 'contact+notifications@kazimirski.fr', subject: "Nouvelle inscription")
  end

  def new_page_submitted(page)
    @page = page
    mail(to: 'contact+notifications@kazimirski.fr', subject: "Nouvelle page transcrite")
  end
end
