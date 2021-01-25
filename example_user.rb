class User
  attr_accessor :name, :email # name,emailのインスタンス変数にアクセスできる

  def initialize(attributes = {}) # User.newをすると自動的に呼び出される特別なメソッド。attributesを引数にとる
    @first_name = attributes[:first_name]
    @last_name = attributes[:last_name]
    @email = attributes[:email]
  end

  def full_name
    @full_name = "#{:first_name}#{:last_name}"
  end

  def formatted_email
    "#{@full_name}<#{@email}>"
  end
endus