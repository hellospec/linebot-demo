class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :verify_authenticity_token

  def create
    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text"
      return
    end
    message = params["events"][0]["message"]["text"]

    matches = match_message(message)
    value = matches[1]
    ActionCable.server.broadcast("line_chatbot", {value: value})

    if value.present?
      reply_message("got x #{value}")
    end
  end
end
