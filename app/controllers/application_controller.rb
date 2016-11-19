# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "请登录"
    end
  end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_path) unless current_user?(@user)
  end

  def admin_user
    redirect_to(root_path) unless current_user.admin?
  end
end
