class ApplicationController < ActionController::Base
  def after_sign_up_path_for
    products_path
  end

  def after_sign_in_path_for
    products_path
  end
end
