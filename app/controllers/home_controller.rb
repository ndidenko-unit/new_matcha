
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
    age_range = validate_age(params)
    min_dob = Time.now - age_range[1].years
    max_dob = Time.now - age_range[0].years
    if params[:search_name].present?
      @users = User.where("name ~* ?", params[:search_name])
                   .where(dob: min_dob..max_dob)
    else
      @users = User.where(dob: min_dob..max_dob)
    end
    @users = (User.where.not(id: current_user.id) - current_user.blocks) if @users.nil?
    @users = @users.paginate(page: params[:page], per_page: 10)
    # @users = User.where("name ~* ?", params[:search]) if params[:search].present?
    # @users = User.all if @users.nil?
    # # @users = @users - current_user - current_user.blocks
    # @users = @users.paginate(page: params[:page], per_page: 10)
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

  def validate_age(params)
    age_min = params[:search_age_min].to_i
    age_max = params[:search_age_max].to_i
    default_range = [0, 120]
    age_max = 120 if age_max == 0
    return default_range if age_min < 0 || age_max < 0
    return default_range if age_max < age_min
    default_range[0] = age_min
    default_range[1] = age_max
    default_range
  end
end
