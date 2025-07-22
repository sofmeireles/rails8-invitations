class UserMailer < ApplicationMailer
  def invitation_email(user, token)
    @user = user
    @invite_url = edit_invitation_url(token: token)

    mail(to: @user.email_address, subject: "You're invited!")
  end
end
