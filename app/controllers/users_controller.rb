class UsersController < ApplicationController
  before_action :set_post
  
  def show
    @posts = @user.posts
  end
  
  private
  
    def set_post
      @user = User.find(params[:id])
    end
end
