# encoding: utf-8
class UsersController < ApplicationController
  skip_before_filter :signed_in_user, only: [:new, :create]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :correct_user_or_admin, only: :show
  before_filter :admin_user, only: [:index, :search, :destroy, :reset_password, :get_by_name]

  def index
    @users = User.order("name asc").paginate(page: params[:page])
  end

  def search
    @name = params[:search][:name]
    if @name == PinYin.abbr(@name)
      @users = User.where("pinyin like ?", "%#{@name}%").order("pinyin asc").paginate(page: params[:page])
    else
      @users = User.where("name like ?", "%#{@name}%").order("name asc").paginate(page: params[:page])
    end
    render 'index'
  end

  def show
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "欢迎使用大童CRM!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def edit
  end

  def update
    if @user.update_attributes(params[:user])
      flash[:success] = "更新成功!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def reset_password
    @user = User.find(params[:id])
    @user.password = "123456"
    @user.password_confirmation = "123456"
    if @user.save
      flash[:success] = "密码重置成功,缺省密码：123456"
      redirect_to @user
    else
      flash[:error] = "密码未能重置，请联系系统管理员!"
      redirect_to error_path
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "成功删除用户."
    redirect_to users_path
  end

  def get_by_name
    if params[:term] == PinYin.abbr(params[:term])
      users = User.where("pinyin like '%#{params[:term]}%'")
    else
      users = User.where("name like '%#{params[:term]}%'")
    end
    data = []
    users.each do |user|
      data << {label: user.full_name, value: user.id}
    end
    render json: data
  end

  def correct_user_or_admin
    @user = User.find(params[:id])
    unless current_user?(@user) or current_user.admin?
      redirect_with_no_rights
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user) 
      redirect_with_no_rights
    end
  end
end
