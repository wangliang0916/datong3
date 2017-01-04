# encoding: utf-8
class CustomersController < CustomerBaseController
  before_filter :admin_user, only: [:list_all, :search_all, :destroy]
  before_filter :correct_customer_user, only: [:edit, :update]
  before_filter :correct_customer_user_or_admin, only: :show

  def index
    @customers = get_customers(current_user.customers)
  end

  def list_all
    @all = true
    @customers = get_customers(Customer)
  end

  def search_all
    @all = true
    @name = params[:search][:name]
    @customers = search_customers(Customer, @name)
    render 'list_all'
  end

  def search
    @name = params[:search][:name]
    @customers = search_customers(current_user.customers, @name)
    render 'index'
  end

  # GET /customers/1
  def show
  end

  # GET /customers/new
  def new
    @customer = Customer.new
  end

  # GET /customers/1/edit
  def edit
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

    redirect_to customers_path 
  end

private
  def get_customers(customers)
    customers.order("name asc").paginate(page: params[:page])
  end

  def search_customers(customers, name)
    if name == PinYin.abbr(name)
     customers.where("pinyin like ?", "%#{name}%").order("pinyin asc").paginate(page: params[:page])
    else
      customers.where("name like ?", "%#{name}%").order("name asc").paginate(page: params[:page])
    end
   
  end

  def get_customer
    Customer.find(params[:id])
  end
end
