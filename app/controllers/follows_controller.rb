
class FollowsController < ApplicationController
  before_action :authenticate_user!
  respond_to :js, only: [:create, :destroy]

  def create
    @user = User.find(params[:user_id])
    current_user.follow(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    current_user.stop_following(@user)
  end

  def block
    @user = User.find(params[:user_id])
    current_user.block(@user)
    current_user.stop_following(@user)
    @user.stop_following(current_user)
    redirect_to blocks_user_path(current_user), notice: 'User was blocked'
  end

  def unblock
    @user = User.find(params[:user_id])
    current_user.unblock(@user)
    redirect_to blocks_user_path(current_user), notice: 'User was unblocked'
  end
end
