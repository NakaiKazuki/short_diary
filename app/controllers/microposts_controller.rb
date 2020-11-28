class MicropostsController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: :destroy

  def create
    @micropost = current_user.microposts.build(micropost_params) if user_signed_in?
    if @micropost.save
      flash[:success] = "今日の日記が作成されました！"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "投稿が削除されました"
    redirect_to root_url
  end

  private
  def micropost_params
    params.require(:micropost).permit(:content, :posted_date, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    flash[:danger] = "他人の投稿は削除できません"
    redirect_to root_url if @micropost.nil?
  end
end
