module SessionsHelper

  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
  end

  # ユーザーのセッションを永続的にする
  def remember(user)
    user.remember # userモデルのrememberメソッドを呼び出し、tokenを発行してdigest_tokenへ保存する
    cookies.permanent.signed[:user_id] = user.id # 署名付きcookiesメソッドとpermanentメソッドで20年で有効期限切れになる、かつuserのidが暗号化されたcookiesを作り、userのidをcookieに保存することで永続的なuser_idにする
    cookies.permanent[:remember_token] = user.remember_token # cookiesメソッドとpermanentメソッドで20年で有効期限切れになる、かつremember_tokenが暗号化されたcookiesを作り、永続的なremember_tokenにする
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id])
      @current_user ||= User.find_by(id: user_id)
    elsif (user_id = cookies.signed[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token])
        log_in user
        @current_user = user
      end
    end
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続セッションを破棄する
  def forget(user)
    user.forget
    cookies.delete(:user_id)
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    session.delete(:user_id)
    @current_user = nil
  end
end