class AssignsController < ApplicationController
  def create
  end

  def destroy
    @customer = Customer.find(params[:id])
    current_user.customers.delete(@customer)
    redirect_to customers_path
  end

  def edit
  end
end
