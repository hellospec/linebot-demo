class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :verify_authenticity_token

	def create
    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text" 
      return 
    end
    message = params["events"][0]["message"]["text"]
    handle_message(message)
	end
end