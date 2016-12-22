class TasksController < ApplicationController
  before_filter :signed_in_user

  def index
    @user = User.find(params[:user_id])
    @tasks = @user.tasks.paginate(page: params[:page])
  end
end
