class StaticPagesController < ApplicationController
  def home
    return unless user_signed_in?

    @micropost = current_user.microposts.build
    @microposts = current_user.microposts.page(params[:page]).per(30)
  end
end
