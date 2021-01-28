class User < ApplicationRecord
before_save { email.downcase! } # 保存する前に小文字に変換する
  validates:name, presence: true, length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i # 文字列先頭、英数字_+-.のいずれかを最低1文字、＠、英数字-.を最低一文字、.、英数字を最低一文字、文字列の末尾、iで締める
  validates:email, presence: true, length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: {case_sensitive: false} # 大文字小文字どちらも同じと認識して一意性を保つ
  has_secure_password # パスワードをハッシュ化し、password_digestに保存、authenticate（引数の文字列がパスワードと一致するとUserオブジェクトを、血がければfalseを返す）メソッド利用可
  validates:password, presence: true, length: { minimum: 6 }

  # 渡された文字列のハッシュ値を返す
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST:
                              BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end
end