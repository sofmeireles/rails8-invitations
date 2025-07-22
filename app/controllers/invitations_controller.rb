class InvitationsController < ApplicationController
  before_action :require_authentication, only: [ :index, :create ]
  before_action :set_user_by_token, only: %i[ edit update ]

  def index
    @accepted_invitations = User.pending_invitations.invert_where
    @pending_invitations = User.pending_invitations
  end

  def create
    email_address = params[:email_address]
    existing_user = User.find_by(email_address: email_address)

    if existing_user
      redirect_to root_path, alert: "User with email #{email_address} has already been invited!"
      return
    end

    Current.user.invite_user!(email_address)
    redirect_to root_path, notice: "Invitation sent to #{email_address}!"
  end

  def edit
  end

  def update
    password_params = params.permit(:password, :password_confirmation)

    if @user.update(password_params.merge(invitation_accepted_at: Time.current))
      redirect_to root_path, notice: "Account activated!"
    else
      redirect_to invitation_path(params[:token]), alert: "Passwords did not match."
    end
  end

  private

  def set_user_by_token
    @user = User.find_by_invitation_token(params[:token])
  rescue ActiveSupport::MessageVerifier::InvalidSignature
    redirect_to root_path, alert: "Invitation link is invalid or has expired."
  end
end
