class Api::SaleOrdersController < ApplicationController
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :authenticate_api!

  def create
    render json: {message: "good job"}
  end
end
