class User < ApplicationRecord
  attr_accessor :remember_token # DBに保存させない属性（カラム）をremember_tokenという名前で作るよ

  before_save { email.downcase! } # 保存する前に小文字に変換する
  validates:name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # 文字列先頭、英数字_+-.のいずれかを最低1文字、＠、英数字-.を最低一文字、.、英数字を最低一文字、文字列の末尾、iで締める
  validates:email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false} # 大文字小文字どちらも同じと認識して一意性を保つ
  has_secure_password # パスワードをハッシュ化し、password_digestに保存、authenticate（引数の文字列がパスワードと一致するとUserオブジェクトを、血がければfalseを返す）メソッド利用可
  validates:password, presence: true, length: { minimum: 6 }

  # 引数で渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST: # テスト中はコストパラメータ（ハッシュを算出するための計算コスト。高ければ高いほど推測困難）を最小にし、本番環境ではしっかり計算する
                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost) # bcryptパスワードを作るライブラリsecure_passwordでハッシュ化されコストパラメータが設定されたハッシュ（パスワード）が生成される
  end

  # ランダムなトークンを返す。これを使い、下記のrememberメソッドを作る
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # 永続セッションのためにユーザーをデータベースに記憶する
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # 渡されたトークンがトークンダイジェストと一致したらtrueを返す
  def authenticated?(remember_token)
    return false if remember_digest.nil? # 記憶ダイジェストがnilの場合にfalseを返す
    BCrypt::Password.new(remember_digest).is_password?(remember_token) # ここのremember_tokenはこのメソッド内のremember_tokenを指している。
  end

  # ユーザーログインを破棄する
  def forget
    update_attribute(:remember_digest, nil)
  end
  
end