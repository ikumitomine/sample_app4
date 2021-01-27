class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:session][:email].downcase) # 送信されたメールアドレスをキーにしてユーザーを特定する
    if user && user.authenticate(params[:session][:password]) # 特定したユーザかつ、DBに保存してあるそのユーザーのパスワードが正しいものであれば、
      log_in(user)
      redirect_to user
    else
      flash.now[:danger] = 'Invalid email/password combination'
      render 'new'
    end
  end

  def destroy
  end

end
