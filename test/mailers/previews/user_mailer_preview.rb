# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/user_mailer/invitation_email
  def invitation_email
    user = User.new(email_address: "demo@example.com")
    token = "sample_invitation_token"

    UserMailer.invitation_email(user, token)
  end
end
