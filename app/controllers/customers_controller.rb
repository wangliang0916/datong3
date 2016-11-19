# encoding: utf-8
class CustomersController < ApplicationController
  before_filter :signed_in_user

  def index
    @customers = current_user.customers.paginate(page: params[:page])
  end

  def search
    if params[:search][:show_all] == "1" then
      @customers = Customer.paginate(page: params[:page])
    else
      @customers = current_user.customers.paginate(page: params[:page])
    end
    render 'index'
  end

  # GET /customers/1
  def show
    @customer = Customer.find(params[:id])
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  def create
    @customer = Customer.new(params[:customer])

    if @customer.save
      current_user.customers << @customer
      flash[:success] = "创建成功！" 
      redirect_to @customer
    else
      render 'new' 
    end
  end

  # PUT /customers/1
  def update
    @customer = Customer.find(params[:id])

    if @customer.update_attributes(params[:customer])
      flash[:success] = "更新成功！" 
      redirect_to @customer
    else
      render 'edit' 
    end
  end

  # DELETE /customers/1
  def destroy
    @customer = Customer.find(params[:id])
    @customer.destroy

    redirect_to customers_url 
  end
end
