module Rboard::Login
  def login
    if request.get? && logged_in?
      flash[:notice] = t(:already_logged_in)
      redirect_back_or_default(forums_path) and return false
    end
    return unless request.post?
    self.current_user = @user = User.authenticate(params[:login], params[:password])
    if logged_in?    
      # #remember_me calls save internally, so don't bother saving it twice
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      else
        current_user.save
      end
      flash[:notice] = t(:logged_in_successfully)
      redirect_back_or_default(forums_path) and return false
    else
      flash[:notice] = t(:username_or_password_incorrect)
    end
  end

  def signup
    if logged_in?
      flash[:notice] = t(:already_logged_in)
      redirect_back_or_default(forums_path)
    end
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(forums_path)
    flash[:notice] = t(:thanks_for_signing_up)
  rescue ActiveRecord::RecordNotSaved, ActiveRecord::RecordInvalid
    flash[:notice] = t(:problem_during_signup)
  end

  def logout
    redirect_to('login') and return false unless logged_in?
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    session[:user] = nil
    flash[:notice] = t(:you_have_been_logged_out)
    redirect_to(forums_path)
  end
end