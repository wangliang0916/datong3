class StaticPagesController < ApplicationController
  skip_before_filter :signed_in_user, only: :help

  def help
  end

  def home
  end

  def error
  end
end
