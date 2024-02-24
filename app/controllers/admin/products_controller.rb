class Admin::ProductsController < ApplicationController
  def new
  end

  def edit
    @product = Product.find params[:id]
  end

  def create
    product = Product.new product_params
    if product.save
      redirect_to admin_path, status: :see_other
    else
      render turbo_stream: [
        turbo_stream.replace(
          "error-message",
          partial: "admin/error_message",
          locals: {object: product}
        )
      ]
    end
  end

  def update
    @product = Product.find params[:id]
    if @product.update(product_params)
      redirect_to admin_path, status: :see_other
    else
      render turbo_stream: [
        turbo_stream.replace(
          "error-message",
          partial: "admin/error_message",
          locals: {object: @product}
        )
      ]
    end
  end

  private

  def product_params
    params.require(:product).permit(:name, :code)
  end
end
