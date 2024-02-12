class FakeInputsController < ApplicationController
  def new
  end

  def create
    value = params[:value]
    ActionCable.server.broadcast("line_chatbot", {value: value})
  end
end
