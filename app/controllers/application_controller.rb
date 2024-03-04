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

  def authenticate_sale_person
    # user must be match one of either cases
    # - a `current_user` who already login from web
    # - a request with params[:line_id] and this line_id match
    # with one of the user record in database
    unless authenticate_user! || match_with_line_id
      render json: "not authorized", status: :unauthorized
    end
  end
end
