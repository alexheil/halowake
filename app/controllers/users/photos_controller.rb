class Users::PhotosController < ApplicationController

  before_action :authenticate_user!, except: :show
  before_action :correct_user, only: :create
  before_action :correct_photo_user, only: :destroy
  before_action :set_user, except: :show

  def show
    @user = User.friendly.find(params[:user_id])
    @album = Album.friendly.find(params[:album_id])
    @photo = Photo.friendly.find(params[:id])
  end

  def create
    @album = Album.friendly.find(params[:album_id])
    @photo = @album.photos.build(photo_params)
    @photo.user_id = @user.id
    if @photo.save
      redirect_to user_album_path(@user, @album)
      flash[:notice] = "You've successfully added a photo!"
    else
      redirect_to (:back)
      flash.now[:alert] = "You've failed!"
    end
  end

  def update
    @album = Album.friendly.find(params[:album_id])
    @photo = Photo.friendly.find(params[:id])
    if @photo.update_attributes(photo_params)
      redirect_to user_album_photo_path(@user, @album, @photo)
      flash[:notice] = "You've successfully updated your item!"
    else
      redirect_to (:back)
      flash.now[:alert] = "You've failed!"
    end
  end

  def destroy
    Photo.friendly.find(params[:id]).destroy
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

    def correct_photo_user
      @photo = Photo.friendly.find(params[:id])
      redirect_to user_path(@photo.user_id) if @photo.user_id != current_user.id
    end

    def photo_params
      params.require(:photo).permit(:title, :image, :remove_image, :description, :resolution, :camera, :lens, :aperture, :exposure, :flash, :focal_length, :iso, :for_sale, :base_price, :shipping_price, :total_price, :currency, :quantity, :is_art, :is_photo, :tool, :medium, :surface, :size, :style, :downloadable, :shippable)
    end

end