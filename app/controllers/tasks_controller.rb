class TasksController < ApplicationController
  before_filter :correct_user_or_admin

  def index
    @tasks = @user.tasks.paginate(page: params[:page])
  end

private
  def correct_user_or_admin
    @user = User.find(params[:user_id])
    unless current_user?(@user) or current_user.admin?
      redirect_with_no_rights
    end
  end
end
