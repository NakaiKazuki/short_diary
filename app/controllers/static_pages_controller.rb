class StaticPagesController < ApplicationController
  def home
    return unless user_signed_in?

    @micropost = current_user.microposts.build
    @q = current_user.microposts.ransack(params[:q])
    @pagy, @microposts = pagy(@q.result(distinct: true), items: 15)
  end
end
