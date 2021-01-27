class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include SessionsHelper  # sessionのモジュール機能を使えるようになる
end
