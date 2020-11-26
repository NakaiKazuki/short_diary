class StaticPagesController < ApplicationController
  def home
    if user_signed_in?
      @micropost = current_user.microposts.build
      @microposts = current_user.microposts.page(params[:page]).per(10)
    end
  end
end
