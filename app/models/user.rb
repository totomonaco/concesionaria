class User < ApplicationRecord
  has_secure_password

  enum :role, { customer: 0, seller: 1 }

  has_many :test_drives, dependent: :destroy
  has_many :sales_as_customer, class_name: "Sale", foreign_key: "customer_id", dependent: :restrict_with_error
  has_many :sales_as_seller, class_name: "Sale", foreign_key: "seller_id", dependent: :restrict_with_error

  scope :customers, -> { where(role: :customer) }
  scope :sellers, -> { where(role: :seller) }

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true,
            format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :password, length: { minimum: 6 }, if: -> { new_record? || !password.nil? }

  def display_name
    "#{name} (#{email})"
  end
end