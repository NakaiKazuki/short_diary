class FavoritesController < ApplicationController
  before_action :authenticate_user!
  before_action :correct_user, only: %i[create destroy]

  def create
    @micropost = Micropost.find(params[:micropost_id])
    current_user.favorite(@micropost)
    respond_to do |format|
      format.html { redirect_to root_url }
      format.js
    end
  end

  def destroy
    favorite = Favorite.find(params[:id])
    @micropost = Micropost.find(favorite.micropost_id)
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

  private

    def correct_user
      micropost = current_user.microposts.find_by(params[:id])
      redirect_to root_url if micropost.nil?
    end
end
