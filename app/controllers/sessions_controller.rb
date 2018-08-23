class SessionsController < ApplicationController
  def new
  end

  def create
    email = params[:session][:email].downcase
    password = params[:session][:password]

    user = User.find_by(email: email)
    if user && user.authenticate(password)
      log_in user
      redirect_to user_url(user)
    else
      # Create error messages.
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
    log_out
    redirect_to root_url
  end
end
