class Vehicle < ApplicationRecord
  belongs_to :vehicle_model
  has_many :test_drives, class_name: "TestDrive", dependent: :destroy
  has_one :sale, dependent: :nullify
  has_many_attached :photos

  def cover_photo
    photos.first if photos.attached?
  end

  enum :currency, { ars: "ars", usd: "usd" }, default: "ars"
  enum :status, { available: 0, reserved: 1, sold: 2 }, default: :available

  scope :available_for_sale, -> { where(status: [:available, :reserved]) }
  scope :by_status, ->(s) { where(status: s) if s.present? && s != "all" }
  scope :by_condition, ->(c) {
    case c.to_s.downcase
    when "used" then where(used: true)
    when "new", "zero_km" then where(used: false)
    end
  }
  scope :by_brand, ->(brand_id) { joins(vehicle_model: :brand).where(brands: { id: brand_id }) if brand_id.present? }
  scope :by_price, ->(order) { order(price: order) if %w[asc desc].include?(order.to_s) }

  def condition
    used? ? "used" : "new"
  end

  validates :vehicle_model, presence: { message: "debe seleccionarse" }
  validates :year, presence: { message: "no puede estar en blanco" }, 
                   numericality: { greater_than: 1980, less_than_or_equal_to: Date.current.year + 1, message: "debe ser un año válido" }
  validates :price, presence: { message: "no puede estar en blanco" }, 
                    numericality: { greater_than: 0, message: "debe ser mayor a 0" }
  validates :km, presence: { message: "no puede estar en blanco" },
                 numericality: { greater_than_or_equal_to: 0, message: "debe ser mayor o igual a 0" }

  def formatted_price
    symbol = usd? ? "USD $ " : "ARS $ "
    amount = price ? (price % 1 == 0 ? price.to_i : price) : 0
    "#{symbol}#{ActiveSupport::NumberHelper.number_to_delimited(amount, delimiter: '.')}"
  end

  def title
    "#{vehicle_model.brand.name} #{vehicle_model.name} (#{year})"
  end

  def display_name
    "#{title} - #{formatted_price}"
  end

  def status_name
    case status
    when "available" then "Disponible"
    when "reserved" then "Reservado"
    when "sold" then "Vendido"
    else status.to_s.humanize
    end
  end
end
