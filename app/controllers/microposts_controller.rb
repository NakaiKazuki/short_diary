class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params) if user_signed_in?
    if @micropost.save
      redirect_to root_url, flash: { success: '今日の日記が作成されました！' }
    else
      @q = current_user.microposts.ransack(params[:q])
      microposts = @q.result(distinct: true)
      @pagy, @microposts = pagy(microposts, items: 30)
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    redirect_to root_url, flash: { success: '投稿が削除されました' }
  end

  private

    def micropost_params
      params.require(:micropost).permit(:content, :picture)
    end

    def correct_user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
