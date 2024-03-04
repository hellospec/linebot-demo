class ProductsController < ApplicationController
  before_action :authenticate_sale_person

  def index
  end

  def show
    id = params[:id]
    is_integer = Integer id
    @product = is_integer ? Product.find(id) : Product.find_by(slug: id)
  end
end
