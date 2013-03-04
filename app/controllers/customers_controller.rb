class CustomersController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_preferences

  def index
    @customers = current_user.customers
  end

  def edit
    @customer = Customer.find(params[:id])
  end

  def new
    @customer = Customer.new
  end

  def create
    @customer = Customer.secure_create(current_user, params[:customer])

    if @customer.valid?
      redirect_to edit_customer_path(@customer), :notice => I18n.t('messages.success')
    else
      flash[:error] = I18n.t('errors.errors.template.body')
      render :new
    end
  end

  def update
    @customer = Customer.secure_update params[:customer]

    if @customer.valid?
      redirect_to edit_customer_path(@customer), :notice => I18n.t('messages.success')
    else
      flash[:error] = I18n.t('errors.errors.template.body')
      render :edit
    end
  end

  def destroy
    Customer.secure_remove(params[:id])

    redirect_to customers_path, :notice => I18n.t('messages.success_remove')
  end

end
