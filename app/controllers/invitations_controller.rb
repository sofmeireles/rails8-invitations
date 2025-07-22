class InvitationsController < ApplicationController
  before_action :require_authentication, only: [:index, :create]

  def index
  end

  def create
    email = params[:email]

    if User.exists?(email_address: email)
      redirect_to root_path, alert: "User with email #{email} already exists!"
    else
      Current.user.invite_user!(email)
      redirect_to root_path, notice: "Invitation sent to #{email}!"
    end
  end

  def edit
    @user = User.find_by_invitation_token(params[:token])
    redirect_to root_path, alert: "Invalid invitation" unless @user
  end

  def update
    @user = User.find_by_invitation_token(params[:token])

    if @user&.update(password_params)
      @user.update!(invitation_accepted_at: Time.current)
      redirect_to root_path, notice: "Account activated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
