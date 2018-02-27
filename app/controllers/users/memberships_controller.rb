class Users::MembershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_user

  def edit
    @membership = @user.membership
  end

  def update
    @membership = @user.membership

    if @membership.copper?
      
    else
      
    end

    if @membership.update_attributes(membership_params)
      redirect_to current_user
    else
      render 'edit'
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

    def membership_params
      params.require(:membership).permit(:copper, :bronze, :silver, :gold, :platinum, :membership_type, :amount, :percent)
    end

end