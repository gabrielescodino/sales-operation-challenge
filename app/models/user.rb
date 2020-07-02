# frozen_string_literal: true

class User < ApplicationRecord
  # :: Associations
  has_many :sales_reports, dependent: :destroy
  has_many :sales, through: :sales_reports

  # :: Validations
  validates :name, :email, presence: true
  validates :email, :google_uid, uniqueness: true

  # :: Methods
  def self.find_or_create_with_omniauth(auth)
    user = find_or_create_by(email: auth.info.email, google_uid: auth.uid.to_s)
    user.assign_attributes(
      name: auth.info.name,
      email: auth.info.email,
      google_uid: auth.uid,
      google_token: auth.credentials.token
    )
    user.save
    user
  end
end
