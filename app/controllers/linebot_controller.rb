class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :verify_authenticity_token

  def create
    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text"
      return
    end
    message = params["events"][0]["message"]["text"]

    capture = LineMessageCapture.new(message)
    if capture.valid? and capture.has_all_attributes?
      ActionCable.server.broadcast("line_chatbot", {value: capture.amount})
      reply_message("roger that")

    else
      reply_message("#{capture.error}\nPlease try again.")
    end
  end
end
