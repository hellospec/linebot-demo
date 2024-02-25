class SalePersonInvitation < ApplicationRecord
  before_create :generate_code
  before_create :set_expires_at

  enum status: {fresh: "fresh", used: "used"}

  private
 
  def generate_code
    self.code = SecureRandom.base36
  end

  def set_expires_at
    self.expires_at = Date.today + 1.days
  end
end
