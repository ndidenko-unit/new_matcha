
class HomeController < ApplicationController
  before_action :set_user, except: :front
  respond_to :html, :js

  def index
    @post = Post.new
    @friends = @user.all_following.unshift(@user)
    @activities = PublicActivity::Activity.where(owner_id: @friends).order(created_at: :desc).paginate(page: params[:page], per_page: 100)
  end

  def front
    @activities = PublicActivity::Activity.where.not(trackable_type: :Follow).joins("INNER JOIN users ON activities.owner_id = users.id").order(created_at: :desc).paginate(page: params[:page], per_page: 100)
  end

  def find_friends
    @users =  (User.where.not(id: current_user.id) - current_user.blocks).paginate(page: params[:page], per_page: 10)
  end

  def chats
    session[:conversations] ||= []
    @users = @user.following_users - @user.blocks
    @conversations = Conversation.includes(:recipient, :messages)
                         .find(session[:conversations])
  end

  private
  def set_user
    @user = current_user
  end
end
