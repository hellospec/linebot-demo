class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def create
    if params["events"].blank?
      # Return 200 for Line messaging api webhook verification
      head :ok and return
    end

    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text"
      return
    end
    line_user_id = params["events"][0]["source"]["userId"]
    text = params["events"][0]["message"]["text"]

    capture = LineMessageCapture.new(text, line_user_id)
    if capture.valid?
      capture.create_sale!
      capture.broadcast_to_dashboard
      reply_message("รับทราบ จะดำเนินการอัพเดต dashboard ให้ต่อไปครับ")

    else
      reply_message("#{capture.error}\nPlease try again.") if capture.error.present?
    end
  end
end
