class TasksController < ApplicationController
  before_filter :signed_in_user

  def index
    @tasks = current_user.tasks.paginate(page: params[:page])
  end
end
