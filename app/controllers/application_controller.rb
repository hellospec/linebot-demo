class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_admin!
    unless current_user.admin?
      redirect_to root_path, status: :see_other
    end
  end

  def authenticate_api!
    user = authenticate_with_http_basic { |email, p| User.authenticate(email, p) }
    if user and user.api?
      @current_user = user
    else
      render json: {error: "Not authorized"}, status: :unauthorized
      return
    end
  end
end
