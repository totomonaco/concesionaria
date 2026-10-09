class Appraisal < ApplicationRecord
  belongs_to :user, optional: true
  has_one_attached :photo

  enum :status, {
    pending:  "pending",
    quoted:   "quoted",
    rejected: "rejected"
  }, default: "pending"

  validates :make,       presence: { message: "no puede estar en blanco" }
  validates :car_model, presence: { message: "no puede estar en blanco" }
  validates :year,       presence: { message: "no puede estar en blanco" },
                         numericality: { greater_than: 1980,
                                         less_than_or_equal_to: Date.current.year + 1,
                                         message: "debe ser un año válido" }
  validates :km,         presence: { message: "no puede estar en blanco" },
                         numericality: { greater_than_or_equal_to: 0, message: "debe ser 0 o mayor" }
  validates :quoted_price, numericality: { greater_than: 0 }, allow_nil: true

  scope :recent_first, -> { order(created_at: :desc) }
  scope :pending_first, -> { order(Arel.sql("CASE status WHEN 'pending' THEN 0 ELSE 1 END"), created_at: :desc) }

  def status_name
    case status
    when "pending"  then "Pendiente"
    when "quoted"   then "Cotizado"
    when "rejected" then "Rechazado"
    end
  end

  def car_title
    "#{make} #{car_model} (#{year})"
  end
end
