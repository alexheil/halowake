class Users::ProfilesController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_user

  def update
    @profile = @user.profile
    @location = @user.location
    @theme = @user.theme
    @location.update_attributes(location_params)
    @theme.update_attributes(theme_params)
    if @profile.update_attributes(profile_params)
      flash[:notice] = "You've successfully updated your profile!"
      redirect_to current_user
    else
      render 'edit'
      flash[:alert] = "You failed to update your profile."
    end
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

    def profile_params
      params.require(:profile).permit(:biography, :first_name, :last_name, :website, :facebook_handle, :facebook_url, :twitter_handle, :twitter_url, :instagram_handle, :instagram_url, :age, :image, :remove_image)
    end

    def location_params
      params.require(:location).permit(:city, :state, :country)
    end

    def theme_params
      params.require(:theme).permit(:main_color, :text_color, :background_color, :link_color, :hover_color)
    end

end