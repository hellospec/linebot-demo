class LinebotController < ApplicationController
  include ReplyLinebot
  skip_before_action :verify_authenticity_token

  def create
    if params["events"].blank?
      # Return 200 for Line messaging api webhook verification
      head :ok and return
    end

    unless params["events"][0]["type"] == "message" && params["events"][0]["message"]["type"] == "text"
      return
    end
    user_id = params["events"][0]["source"]["userId"]
    text = params["events"][0]["message"]["text"]

    capture = LineMessageCapture.new(text)
    if capture.valid?
      create_sale_record(user_id, capture)

      ActionCable.server.broadcast("line_chatbot", {value: capture.amount})
      reply_message("roger that")

    else
      reply_message("#{capture.error}\nPlease try again.") if capture.error.present?
    end
  end

  private

  def create_sale_record(user_id, capture)
    Sale.create(
      sale_person_line_id: user_id,
      amount: capture.amount,
      product_code: capture.product,
      channel_code: capture.sale_channel
    )
  end
end
