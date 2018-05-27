class UsersController < ApplicationController
  before_action :set_post
  
  def show
    @posts = @user.posts
  end
  
  def follow
    @user.toggle_like(current_user)
    redirect_back(fallback_location: root_path)
  end
  
  private
  
    def set_post
      @user = User.find(params[:id])
    end
end
