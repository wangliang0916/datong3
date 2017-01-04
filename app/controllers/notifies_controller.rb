# encoding: utf-8
class NotifiesController < CustomerBaseController
  before_filter :correct_customer_user, only: [:new, :edit, :update, :create, :destroy]
  before_filter :correct_customer_user_or_admin, only: [:index]

  def index
    @notifies = @customer.notifies
  end

  def new
    @notify = @customer.notifies.build
  end

  def create
    @notify = eval(params[:notify][:type] + "Notify.new") 
    @notify.content = params[:notify][:content]
    @notify.date = params[:notify][:date]
    @notify.time = params[:notify][:time]
    if @customer.notifies << @notify
      flash[:success] = "成功创建通知!"
      redirect_to customer_notifies_path(@customer)
    else
      render 'new'
    end
  end

  def edit
    @notify = @customer.notifies.find params[:id]
  end

  def update
    @notify = Notify.find params[:id]
    @notify.content = params[:notify][:content]
    @notify.date = params[:notify][:date]
    @notify.time = params[:notify][:time]
    if @notify.save
      flash[:success] = "成功更新通知!"
      redirect_to customer_notifies_path(@customer)
    else
      render 'edit'
    end
  end

  def destroy
    Notify.find(params[:id]).destroy
    flash[:success] = "成功删除通知!"
    redirect_to customer_notifies_path(@customer)

  end

private
  def get_customer
    Customer.find(params[:customer_id])
  end
end
