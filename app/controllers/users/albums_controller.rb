class Users::AlbumsController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :correct_user, only: :create
  before_action :correct_album_user, only: :destroy
  before_action :set_user, except: :show

  def show
    @user = User.friendly.find(params[:user_id])
    @album = Album.friendly.find(params[:id])
    if user_signed_in? && current_user == @user
      @profile = current_user.profile
      @location = current_user.location
      @theme = current_user.theme
      @photo = Photo.new
    end
  end

  def create
    @album = @user.albums.build(album_params)
    if @album.save
      redirect_to user_path(@user)
      flash[:notice] = "You've successfully added a photo album!"
    else
      render 'new'
      flash.now[:alert] = "You've failed!"
    end
  end

  def update
    @album = Album.friendly.find(params[:id])
    if @album.update_attributes(album_params)
      redirect_to user_album_path(@user, @album)
      flash[:notice] = "You've successfully updated your item!"
    else
      redirect_to (:back)
      flash.now[:alert] = "You've failed!"
    end
  end

  def destroy
    Album.friendly.find(params[:id]).destroy
    redirect_to user_path(@user)
  end

  private

    def set_user
      @user = current_user
    end

    def correct_user
      @user = User.friendly.find(params[:user_id])
      if current_user != @user
        redirect_to user_path(@user)
        flash[:alert] = "This is not your profile."
      end
    end

    def correct_album_user
      @album = Album.friendly.find(params[:id])
      redirect_to user_path(@album.user_id) if @album.user_id != current_user.id
    end

    def album_params
      params.require(:album).permit(:title, :description)
    end

end