# encoding: utf-8
class UsersController < ApplicationController
  before_filter :signed_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_filter :correct_user, only: [:edit, :update]
  before_filter :admin_user, only: [:index, :destroy]

  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
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
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:success] = "更新成功!"
      sign_in @user
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "成功删除用户."
    redirect_to users_path
  end

  def search
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

end
