class UserMailer < ActionMailer::Base
  default from: "ihateror@gmail.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mail.challenge.subject
  #
  def challenge(email, user, tmp)
    hscore = tmp.score
    @greeting = "Hi"
    @link = "http://sturdy-winterfell-72-145566.apse1.nitrousbox.com/"
    @body = user.username + "has challenged you to beat his score : " + hscore.to_s + " in 4 pics 1 word."
    mail :to => email, :subject => "Challenge: 4 pics 1 word"
  end
end
