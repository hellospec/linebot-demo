class DashboardChannel < ApplicationCable::Channel
  def subscribed
    stream_from "line_chatbot"
  end
end
