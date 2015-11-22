class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy,
                                        :following, :followers]
  before_action :correct_user,   only: [:edit, :update]

  skip_before_action :verify_authenticity_token
  
  def index
    @users = User.paginate(page: params[:page])
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
    respond_to do |f|
        f.html
        f.json {render json: {signup: "okkkkkkk"}, status: :ok}
      end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      respond_to do |f|
        f.html {
          log_in @user
          flash[:success] = "Welcome to the Sample App!"
          redirect_to @user
        }
        f.json {render json: {user: @user}, status: :ok}
      end
      # Handle a successful save.
    else
      respond_to do |f|
        f.html {
          render 'new'
        }
        f.json {render json: {error: @user.errors.full_messages}, status: :ok}
      end
    end
  end
  def edit
    @user = User.find(params[:id])
    respond_to do |f|
      f.html
      f.json {render json: {user: @user}, status: :ok}     
    end
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      respond_to do |f|
        f.html{
            flash[:success] = "Profile updated"
            redirect_to @user
        }
        f.json {render json: {user: @user}, status: :ok}     
      end
    else
      respond_to do |f|
        f.html {
          render 'edit'
        }
        f.json {render json: {error: @user.errors.full_messages}, status: :ok}
      end
    end
  end
  def following
    @title = "Following"
    @user  = User.find(params[:id])
    @users = @user.following.paginate(page: params[:page])
    render 'show_follow'
  end

  def followers
    @title = "Followers"
    @user  = User.find(params[:id])
    @users = @user.followers.paginate(page: params[:page])
    render 'show_follow'
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end
    def logged_in_user
      unless logged_in?
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    def correct_user
      if current_user.admin?
        return true
      else
        @user = User.find(params[:id])
        redirect_to(root_url) unless current_user?(@user)
      end
    end
    def admin_user
      redirect_to(root_url) unless current_user.admin?
    end
end