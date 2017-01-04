# encoding: utf-8
class AssignsController < CustomerBaseController
  before_filter :admin_user, only: [:create, :edit]
  before_filter :correct_customer_user_or_admin, only: :destroy

  def create
    @customer = get_customer
    @user = User.find(params[:user_id])
    if @customer.users.include?(@user)
      flash[:notice] = "重复指派!"
    else
      if @customer.users << @user
        flash[:success] = "客户专员指派成功!"
      else
        flash[:error] = "客户专员指派失败，请联系系统管理员!"
      end
    end
    redirect_to assign_edit_path(customer_id: @customer.id)
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.customers.delete(@customer)
    respond_to do |format|
      
      format.html do 
        flash[:success] = "成功取消客户专员指派!"
        redirect_to customers_path
      end

      format.js
    end
  end

  def edit
    store_location
    @customer = get_customer 
  end

private
  def get_customer
    Customer.find(params[:customer_id])
  end

end
