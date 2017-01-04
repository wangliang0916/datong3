class CustomerBaseController < ApplicationController
private
  def correct_customer_user_or_admin
    @customer = get_customer
    unless @customer.users.include?(current_user) or current_user.admin?
      redirect_with_no_rights
    end
  end

  def correct_customer_user
    @customer = get_customer
    unless @customer.users.include?(current_user)
      redirect_with_no_rights
    end
  end
end
