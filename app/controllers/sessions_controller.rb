class SessionsController < ApplicationController

  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    respond_to do |format|
      if user && user.authenticate(params[:session][:password])
        log_in user
        format.html do
          params[:session][:remember_me] == '1' ? remember(user) : forget(user)
          redirect_to user
        end
        # Log the user in and redirect to the user's show page.
        format.json {render json: {user: user.as_json}, status: :ok}
      else
        format.html do
          flash.now[:danger] = 'Invalid email/password combination' # Not quite right!
          render 'new'
        end
        format.json {render json: {message: "not found user"}, status: 401}
      end
    end
  end

  def destroy
    respond_to do |format|
      if logged_in?
        format.html do
          log_out 
          redirect_to root_url
        end
        format.json {render json: {message: "ok logout"}, status: :ok}
      end
    end
  end
end