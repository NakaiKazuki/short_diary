class StaticPagesController < ApplicationController
  def home
    return unless user_signed_in?

    @micropost = current_user.microposts.build
    @q = current_user.microposts.ransack(params[:q])
    microposts = @q.result(distinct: true)
    @pagy, @microposts = pagy(microposts, items: 30)
  end
end
