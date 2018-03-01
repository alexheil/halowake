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
      # Find or create customer 
      # if @user.customer_id.blank? / create customer else retreive customer
      # create a Stripe membership
      membership = Stripe::Subscription.create({
        customer: @user.customer_id,
      })

      membership.save

      if membership.save
        @membership.update_attributes(
          membership_type: params[:membership][:membership_type]
        )
      end

    else
      # grab Stripe membership and update it
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