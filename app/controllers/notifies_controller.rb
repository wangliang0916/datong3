# encoding: utf-8
class NotifiesController < ApplicationController
  def new
    @customer = Customer.find params[:customer_id]
  end

  def create
    @customer = Customer.find params[:notify][:customer_id]
    @notify = @customer.notifies.build
    @notify.content = params[:notify][:content]
    @notify.date = params[:notify][:date]
    @notify.time = params[:notify][:time]
    if @notify.save
      flash[:success] = "成功创建通知!"
      redirect_to @customer
    else
      render 'new'
    end
  end

  def edit
    @customer = Customer.find params[:customer_id]
    @notify = @customer.notifies.find params[:id]
  end

  def update
    @customer = Customer.find params[:customer_id]
    @notify = Notify.find params[:id]
    @notify.content = params[:notify][:content]
    @notify.date = params[:notify][:date]
    @notify.time = params[:notify][:time]
    if @notify.save
      flash[:success] = "成功更新通知!"
      redirect_to @customer
    else
      render 'edit'
    end
  end

  def destroy
    @customer = Customer.find params[:customer_id]
    Notify.find(params[:id]).destroy
    flash[:success] = "成功删除通知!"
    redirect_to @customer

  end

end
