class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(@micropost)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    @micropost = Favorite.find(params[:id]).micropost
    current_user.unfavorite(@micropost)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def index
    favorites = current_user.favorites
    @pagy, @fav_microposts = pagy(Micropost.where(id: favorites.pluck(:micropost_id)))
  end
end
