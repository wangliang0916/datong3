# encoding: utf-8
class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper

  before_filter :signed_in_user
  
  rescue_from ActiveRecord::RecordNotFound, with: :redirect_to_404

private
  def signed_in_user
    unless signed_in?
      store_location
      redirect_to signin_path, notice: "请登录"
    end
  end

  def admin_user
    if !current_user.admin?
      redirect_with_no_rights
    end
  end


  def redirect_to_404
    redirect_to '/404.html'
  end

  def redirect_with_no_rights
    flash[:error] = "没有权限，请联系系统管理员！"
    redirect_to(error_path)
  end
end
