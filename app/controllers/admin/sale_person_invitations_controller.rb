class Admin::SalePersonInvitationsController < ApplicationController
  before_action :authenticate_admin!

  def create
    invitation = SalePersonInvitation.create!
    @url = "#{ENV['APP_URL']}/sale_persons/line_login?invitation_code=#{invitation.code}"
  end
end
