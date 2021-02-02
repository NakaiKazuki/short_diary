class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user

  def create
    micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(micropost)
    redirect_to root_path
    # respond_to do |format|
    #   format.html { redirect_to @book }
    #   format.js
    # end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    micropost = Micropost.find(favorite.micropost_id)
    current_user.unfavorite(micropost)
    redirect_to root_path
    # respond_to do |format|
    #   format.html { redirect_to @book }
    #   format.js
    # end
  end

  private

    def correct_user
      @micropost = current_user.microposts.find_by(params[:id])
      redirect_to root_url if @micropost.nil?
    end
end
