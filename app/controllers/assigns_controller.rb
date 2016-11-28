class AssignsController < ApplicationController
  def create
  end

  def destroy
    @customer = Customer.find(params[:customer_id])
    @user = User.find(params[:user_id])
    @user.customers.delete(@customer)
    redirect_to customer_path(@customer)
  end

  def edit
    @customer = Customer.find(params[:id])
  end
end
