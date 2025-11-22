class QrSignupToken < ApplicationRecord
  belongs_to :user, optional: true

  before_create :generate_token
  before_create :set_expiration

  def expired?
    Time.current > expires_at
  end

  private

  def generate_token
    self.token = SecureRandom.urlsafe_base64(20)
  end

  def set_expiration
    self.expires_at = 2.hours.from_now
  end
end
