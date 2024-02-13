class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :verify_authenticity_token

  def create
    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text"
      return
    end
    message = params["events"][0]["message"]["text"]

    value = match_message(message)
    # TODO:
    # Boardcast value to line_chatbot channel and then
    # re-render the value on dashboard
    # ActionCable.server.broadcast("line_chatbot", {value: value})

    if value.present?
      reply_message("got x #{value[1]}")
    end
  end
end
