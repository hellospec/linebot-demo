class ProductsController < ApplicationController
  before_action :authenticate_sale_person

  def index
  end

  def show
    id = params[:id]
    @product = is_integer?(id) ? Product.find(id) : Product.find_by(slug: id)
  end

  private

  def is_integer?(id)
    !!Integer(id)
  rescue ArgumentError, TypeError
    false
  end
end
