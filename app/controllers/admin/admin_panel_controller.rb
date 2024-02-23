class Admin::AdminPanelController < ApplicationController
  before_action :authenticate_admin!

  def show
    @sales = Sale.all.order(created_at: :desc)
  end
end
