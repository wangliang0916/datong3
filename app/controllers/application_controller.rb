# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :signed_in_user

private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "请登录"
    end
  end

  def correct_user_or_admin
    @user = User.find(params[:id])
    unless current_user?(@user) or current_user.admin?
      flash[:error] = "没有访问其他用户的权限，请联系系统管理员！"
      redirect_to(error_path)
    end
  end

  def correct_user
    @user = User.find(params[:id])
    unless current_user?(@user) 
      flash[:error] = "没有访问其他用户的权限，请联系系统管理员！"
      redirect_to(error_path)
    end
  end

  def admin_user
    if !current_user.admin?
      flash[:error] = "没有管理员权限，请联系系统管理员！"
      redirect_to(error_path)
    end
  end
end
