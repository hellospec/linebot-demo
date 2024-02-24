class Admin::SalePersonsController < ApplicationController
  def new
    @sale_person = User.new
  end

  def create
    @sale_person = User.new(
      email: params[:user][:email],
      password: "password",
      password_confirmation: "password"
    )
    if @sale_person.save
      redirect_to admin_path, status: :see_other
    else
      render turbo_stream: [
        turbo_stream.replace(
          "error-message",
          partial: "admin/error_message",
          locals: {object: @sale_person}
        )
      ]
    end
  end
end

