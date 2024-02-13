module ReplyLinebot
  def match_message(message)
    message.downcase.match(/^ppx\s+(\d{1,})\b/)
  end

  def handle_message(message)
    result = match_message(message)
    if result.present?
      reply_message("got x #{result[1]}")
    end
  end

  def reply_message(message)
    access_token = ENV["LINE_MSG_CHANNEL_TOKEN"]
    conn = Faraday.new(
      url: "https://api.line.me/v2/bot/message/reply",
      headers: {"Content-Type": "application/json", Authorization: "Bearer #{access_token}"}
    )
    conn.post do |req|
      req.body = {
        replyToken: params["events"][0]["replyToken"],
        messages: [
          {
            type: "text",
            text: message.to_s
          }
        ]
      }.to_json
    end
  end
end
