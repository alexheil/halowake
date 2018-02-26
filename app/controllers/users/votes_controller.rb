class Users::VotesController < ApplicationController

  before_action :authenticate_user!

  def create
    @vote = Vote.new
    @user = User.friendly.find(params[:user_id])
    @album = Album.friendly.find(params[:album_id])
    @photo = Photo.friendly.find(params[:photo_id])
    @vote.photo_id = @photo.id
    @vote.user_id = current_user.id
    if @vote.save
      respond_to do |format|
        format.html { redirect_to (:back) }
        format.js { render :action => "votes" }
      end
    else
      render 'new'
      flash.now[:alert] = "You've failed!"
    end
  end

  def destroy
    @user = User.friendly.find(params[:user_id])
    @album = Album.friendly.find(params[:album_id])
    @photo = Photo.friendly.find(params[:photo_id])
    current_user.unvote(@photo)
    respond_to do |format|
      format.html { redirect_to (:back) }
      format.js { render :action => "votes" }
    end
  end

end