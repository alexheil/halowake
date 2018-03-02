class Users::MembershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_user

  def edit
    @membership = @user.membership
  end

  def update
    @membership = @user.membership
    
    # find customer
    customer = Stripe::Customer.retrieve(@user.customer_id)

    # if user has subscription find it if not create it

    if @membership.membership_id.blank?
      # create a Stripe membership
      # membership = Stripe::Subscription.create({
      #  customer: @user.customer_id,
      # })

      # membership.save

      # if membership.save
      #  @membership.update_attributes(
      #    membership_type: params[:membership][:membership_type]
      #  )
      # end

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
      params.require(:membership).permit(:membership_id, :copper, :bronze, :bronze_id, :silver, :silver_id, :gold, :gold_id, :platinum, :platinum_id, :membership_type, :amount, :percent)
    end

end