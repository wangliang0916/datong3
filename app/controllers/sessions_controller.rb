# encoding: utf-8
class SessionsController < ApplicationController
  skip_before_filter :signed_in_user

  def new
  end

  def create
    user = User.find_by_mobile_phone(params[:session][:mobile_phone])
    if user && user.authenticate(params[:session][:password])
      sign_in user, params[:session][:remember_me]
      redirect_back_or user_tasks_path(user)
    else
      flash.now[:error] = "手机号码或密码错误！"
      render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to signin_path
  end
end
