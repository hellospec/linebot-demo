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
    capture.sale_person_line_id = user_id
    if capture.valid?
      create_sale_record(capture)
      broadcast_to_dashboard(capture)

      reply_message("roger that")

    else
      reply_message("#{capture.error}\nPlease try again.") if capture.error.present?
    end
  end

  private

  def create_sale_record(capture)
    Sale.create(
      amount: capture.amount,
      product_code: capture.product,
      channel_code: capture.sale_channel,
      sale_person_line_id: capture.sale_person_line_id
    )
  end

  def broadcast_to_dashboard(capture)
    ActionCable.server.broadcast(
      "line_chatbot",
      {
        amount: capture.amount,
        product: capture.product,
        saleChannel: capture.sale_channel,
        salePersonLineId: capture.sale_person_line_id
      }
    )
  end
end
