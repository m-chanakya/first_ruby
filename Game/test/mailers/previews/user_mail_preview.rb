# Preview all emails at http://localhost:3000/rails/mailers/user_mail
class UserMailPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/user_mail/challenge
  def challenge
    UserMail.challenge
  end

end
