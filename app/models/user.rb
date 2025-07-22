class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  scope :pending, -> { where(invitation_accepted_at: nil) }
  scope :accepted, -> { where.not(invitation_accepted_at: nil) }

  validates :email_address, presence: true, uniqueness: true
  validates :password, presence: true, on: :create

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  generates_token_for :invitation, expires_in: 7.days do
    # Token becomes invalid when invitation_accepted_at changes
    invitation_accepted_at
  end

  # NOTE: For a blog post this is fine to keep in the model, but consider moving to a service object
  def invite_user!(email)
    invited_user = User.create!(
      email_address: email,
      password: SecureRandom.hex(16) # temporary password
    )

    # Send invitation email using the generated token
    token = invited_user.generate_token_for(:invitation)
    UserMailer.invitation_email(invited_user, token).deliver_later
  end

  def self.find_by_invitation_token(token)
    find_by_token_for(:invitation, token)
  end

  def invitation_token
    generate_token_for(:invitation)
  end
end
