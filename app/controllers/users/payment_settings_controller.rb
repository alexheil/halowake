class Users::PaymentSettingsController < ApplicationController
  
  before_action :authenticate_user!
  before_action :correct_user
  before_action :set_user
  before_action :have_merchant_account, only: [:new, :create]

  def new
    @payment = PaymentSetting.new
  end

  def create

    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    @account = Stripe::Account.create(
      managed: true,
      country: params[:payment_setting][:country],
      email: @user.email,
      tos_acceptance: {
        ip: request.remote_ip,
        date: Time.now.to_i
      },
      legal_entity: {
        dob: {
          month: params[:payment_setting][:month],
          day: params[:payment_setting][:day],
          year: params[:payment_setting][:year]
        },
        first_name: params[:payment_setting][:first_name],
        last_name: params[:payment_setting][:last_name],
        type: 'individual'
      }
    )

    if @account.save
      @payment = @user.create_payment_setting(
        first_name: @account.legal_entity.first_name,
        last_name: @account.legal_entity.last_name,
        month: @account.legal_entity.dob.month,
        day: @account.legal_entity.dob.day,
        year: @account.legal_entity.dob.year,
        currency: @account.default_currency,
        country: @account.country,
        stripe_id: @account.id
      )
      redirect_to edit_payment_setting_path(@user, @payment)
      flash[:notice] = "before we can transfer your payments we need more information."
    else
      redirect_to user_path(@user)
      flash[:alert] = "your merchant account failed to create."
    end

  end

  def edit
    @payment = @user.payment_setting
  end

  def update
    @payment = @user.payment_setting

    Stripe.api_key = Rails.configuration.stripe[:secret_key]
    account = Stripe::Account.retrieve(@payment.stripe_id)

    if params[:payment_setting][:bank_account_number].present?
      account.external_accounts.create(
        external_account: {
          object: 'bank_account',
          account_number: params[:payment_setting][:bank_account_number],
          routing_number: params[:payment_setting][:bank_routing_number],
          country: account.country,
          currency: params[:payment_setting][:currency]
        }
      )
    end

    account.legal_entity.address.line1 = params[:payment_setting][:line1]
    account.legal_entity.address.city = params[:payment_setting][:city]
    account.legal_entity.address.postal_code = params[:payment_setting][:postal_code]
    account.legal_entity.personal_address.line1 = params[:payment_setting][:line1] unless account.country == 'US'
    account.legal_entity.personal_address.city = params[:payment_setting][:city] unless account.country == 'US'
    account.legal_entity.personal_address.postal_code = params[:payment_setting][:postal_code] unless account.country == 'US'
    account.legal_entity.address.state = params[:payment_setting][:state]
    account.legal_entity.ssn_last_4 = params[:payment_setting][:ssn_last_4] if params[:payment_setting][:ssn_last_4]
    account.legal_entity.personal_id_number = params[:payment_setting][:personal_id_number] if params[:payment_setting][:personal_id_number]
    account.default_currency = params[:payment_setting][:currency]

    account.save

    if account.save
      @payment.update_attributes(
        first_name: params[:payment_setting][:first_name],
        last_name: params[:payment_setting][:last_name],
        month: params[:payment_setting][:month],
        day: params[:payment_setting][:day],
        year: params[:payment_setting][:year],
        currency: account.default_currency
      )
      if @payment.save
      redirect_to user_path(@user)
      flash[:notice] = "you've updated your merchant account."
      else
        render 'edit'
      end
    else
      redirect_to user_path(@user)
      flash[:alert] = "your merchant account failed to update."
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
        flash[:alert] = "this is not you."
      end
    end

    def have_merchant_account
      @user = current_user
      if @user.payment_setting
        @payment = @user.payment_setting
        redirect_to edit_payment_setting_path(@user, @payment) if @payment.country.present?
      end
    end

end