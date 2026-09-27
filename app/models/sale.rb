class Sale < ApplicationRecord
  belongs_to :vehicle
  belongs_to :customer, class_name: "User"
  belongs_to :seller, class_name: "User"

  enum :currency, { ars: "ars", usd: "usd" }, default: "ars"
  enum :payment_method, {
    cash: "cash",
    transfer: "transfer",
    financed: "financed",
    trade_in: "trade_in"
  }, default: "cash"

  validates :price, presence: { message: "no puede estar en blanco" },
                    numericality: { greater_than: 0, message: "debe ser mayor a 0" }
  validates :sold_at, presence: { message: "no puede estar en blanco" }
  validates :vehicle, presence: true
  validates :customer, presence: true
  validates :seller, presence: true
  validate :vehicle_must_be_available_or_reserved, on: :create

  after_create :mark_vehicle_as_sold
  after_destroy :mark_vehicle_as_available

  scope :recent_first, -> { order(sold_at: :desc, created_at: :desc) }

  def payment_method_name
    case payment_method
    when "cash" then "Efectivo"
    when "transfer" then "Transferencia bancaria"
    when "financed" then "Financiación / Crédito"
    when "trade_in" then "Permuta (Entrega de usado)"
    else payment_method.to_s.humanize
    end
  end

  def formatted_price
    symbol = usd? ? "USD $ " : "ARS $ "
    amount = price ? (price % 1 == 0 ? price.to_i : price) : 0
    "#{symbol}#{ActiveSupport::NumberHelper.number_to_delimited(amount, delimiter: '.')}"
  end

  def formatted_date
    sold_at&.strftime("%d/%m/%Y")
  end

  private

  def vehicle_must_be_available_or_reserved
    return if vehicle.blank?

    if vehicle.sold?
      errors.add(:vehicle, "ya fue vendido anteriormente y no puede venderse nuevamente")
    end
  end

  def mark_vehicle_as_sold
    vehicle.update_column(:status, Vehicle.statuses[:sold])
  end

  def mark_vehicle_as_available
    vehicle.update_column(:status, Vehicle.statuses[:available]) if vehicle.present?
  end
end
