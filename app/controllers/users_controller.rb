class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params) # =params[:user] = 入力した情報のハッシュ形式
    if @user.save
      log_in @user
      flash[:success] = "Wlcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end


  def show
    @user = User.find(params[:id])
  end

  private
    # user_paramsの中には以下のデータのみを許可して保存する。あとエバ、adminなどを追加して保存させ、アプリを操作されない用にする
    def user_params
      params.require(:user).permit(:name, :email, :password, :password_confirmation)
    end
end
