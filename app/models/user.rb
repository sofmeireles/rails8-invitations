class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  # Add invitation methods
  def generate_invitation_token
    self.class.verifier.generate({ user_id: id }, expires_in: 7.days)
  end

  def self.find_by_invitation_token(token)
    data = verifier.verify(token)
    find_by(id: data["user_id"])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    nil
  end

  def invitation_accepted?
    invitation_accepted_at.present?
  end

  def invite_user!(email)
    invited_user = User.create!(
      email_address: email,
      password: SecureRandom.hex(16) # temp password
    )

    # Send email
    token = invited_user.generate_invitation_token
    UserMailer.invitation_email(invited_user, token).deliver_later

    invited_user
  end

  private

  def self.verifier
    ActiveSupport::MessageVerifier.new(Rails.application.secret_key_base)
  end
end
