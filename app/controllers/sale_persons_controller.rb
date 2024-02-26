class SalePersonsController < ApplicationController
  skip_before_action :authenticate_user!

  def new
    line_auth_code = params[:code]
    csrf_token = params[:state]
    @invitation = find_invitation_by(csrf_token)
    if line_auth_code and csrf_token and @invitation
      access_token = get_access_token(line_auth_code)
      line_profile = get_line_profile(access_token)
      @sale_person = User.new(
        line_user_id: line_profile["userId"],
        line_display_name: line_profile["displayName"],
        line_picture_url: line_profile["pictureUrl"]
      )

    else
      render plain: "Invalid request" and return
    end
  end

  def create
    @sale_person = User.new(user_params)
    if @sale_person.save
      invitation = SalePersonInvitation.find_by_code params[:invitation_code]
      invitation.used!

      sign_in(:user, @sale_person)
      redirect_to root_path
    end
  end

  def line_login
    if validate_invitation_code
      csrf_token = SecureRandom.base58(12)
      @invitation_code.csrf_token = csrf_token
      @invitation_code.save

      line_auth_url = "https://access.line.me/oauth2/v2.1/authorize?response_type=code&client_id=#{ENV['LINE_LOGIN_CHANNEL_ID']}&state=#{csrf_token}&scope=profile%20openid&redirect_uri=#{redirect_uri}"
      redirect_to line_auth_url, allow_other_host: true
    else
      render plain: "Invalid invitation code"
    end
  end

  private

  def user_params
    params.require(:user).permit(
      :email, 
      :password,
      :password_confirmation,
      :line_user_id,
      :line_display_name,
      :line_picture_url
    )
  end

  def find_invitation_code
    code = params[:invitation_code]
    @invitation_code ||= SalePersonInvitation.find_by_code code
  end

  def validate_invitation_code
    find_invitation_code
    return false if @invitation_code.blank?

    !@invitation_code.expired?
  end

  def find_invitation_by(csrf_token)
    SalePersonInvitation.find_by_csrf_token(csrf_token)
  end

  def redirect_uri
    ERB::Util.url_encode(ENV['LINE_LOGIN_REDIRECT_SALE_REGISTRATION'])
  end

  def get_line_profile(access_token)
    conn = Faraday.new(
      url: 'https://api.line.me',
      headers: {'Authorization' => "Bearer #{access_token}"}
    )
    resp = conn.get("/v2/profile")
    JSON.parse(resp.body)
  end

  def get_access_token(line_auth_code)
    conn = Faraday.new(
      url: 'https://api.line.me',
      headers: {'Content-Type' => 'application/x-www-form-urlencoded'}
    )
    resp = conn.post("/oauth2/v2.1/token", {
                      grant_type: "authorization_code",
                      code: line_auth_code,
                      client_id: ENV["LINE_LOGIN_CHANNEL_ID"],
                      client_secret: ENV["LINE_LOGIN_CHANNEL_SECRET"],
                      redirect_uri: ENV['LINE_LOGIN_REDIRECT_SALE_REGISTRATION']
                    })
    body = JSON.parse(resp.body)
    # Since the line_auth_code value can be used only one time, if user refresh the page, 
    # we need to request to Line.access to get that authorization code again
    if body["error"]
      csrf_token = params[:state]
      invitation = find_invitation_by(csrf_token)
      redirect_to "/sale_persons/line_login?invitation_code=#{invitation.code}",
        status: :see_other,
        allow_other_host: true
      return
    end

    body["access_token"]
  end
end
