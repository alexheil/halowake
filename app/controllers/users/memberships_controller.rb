class Users::MembershipsController < ApplicationController

  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_user

  def edit
    @membership = @user.membership
  end

  def update
    @membership = @user.membership

    # update current_id to match plan id
    @membership.update_attributes(
      current_id: params[:membership][:membership_type] + "_id"
    )
   
    Stripe.api_key = "sk_test_ECd3gjeIEDsGkySmF8FQOC5i"

    # find customer
    customer = Stripe::Customer.retrieve(@user.customer_id)

    # if user has subscription find it if not create it
    if @membership.membership_id.blank?
      # create a Stripe membership
      subscription = Stripe::Subscription.create({
      customer: customer.id,
        items: [{plan: @membership.current_id}],
      })
    else
      # grab Stripe membership and update it
      subscription = Stripe::Subscription.retrieve(@membership.membership_id)
      subscription.items = [{
        id: subscription.items.data[0].id,
        plan: @membership.current_id
      }]
    end

    subscription.save

    if subscription.save
      @membership.update_attributes(
        membership_id: subscription.id,
        membership_type: params[:membership][:membership_type]
      )
      redirect_to user_path(@user)
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
      params.require(:membership).permit(:membership_id, :current_id, :copper, :bronze, :bronze_id, :silver, :silver_id, :gold, :gold_id, :platinum, :platinum_id, :membership_type, :amount, :percent)
    end

end