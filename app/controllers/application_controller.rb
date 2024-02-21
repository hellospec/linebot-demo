class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def authenticate_admin!
    unless current_user.admin?
      redirect_to root_path, status: :see_other
    end
  end
end
