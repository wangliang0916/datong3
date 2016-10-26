# encoding: utf-8
class SessionsController < ApplicationController
  def new
    
  end

  def create
    user = User.find_by_mobile_phone(params[:session][:mobile_phone])
    if user && user.authenticate(params[:session][:password])
      sign_in user
      redirect_to user
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