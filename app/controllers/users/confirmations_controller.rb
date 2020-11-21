# frozen_string_literal: true
class Users::ConfirmationsController < Devise::ConfirmationsController
  before_action :logout_user , only: [:new,:create,:show]
  # GET /resource/confirmation/new
  def new
    super
  end

  # POST /resource/confirmation
  def create
    super
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  def show
    super
  end
  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  private
  # ログインしているユーザーに対するアクセス制限
  def logout_user
    if user_signed_in?
      flash[:alert] = "ログイン時にはアクセスできません。"
      redirect_to root_path
    end
  end
end
