class Vehicle < ApplicationRecord
  belongs_to :vehicle_model
  has_many :test_drives, class_name: "TestDrive", dependent: :destroy

  enum :currency, { ars: "ars", usd: "usd" }, default: "ars"

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
end
