class TestDrive < ApplicationRecord
  belongs_to :vehicle
  belongs_to :user

  enum :status, { pending: 0, confirmed: 1, cancelled: 2 }, default: :pending

  scope :recent_first, -> { order(scheduled_date: :desc, scheduled_time: :desc) }
  scope :chronological, -> { order(scheduled_date: :asc, scheduled_time: :asc) }
  scope :by_status, ->(s) { where(status: s) if s.present? && s != "all" }
  scope :for_vehicle, ->(v_id) { where(vehicle_id: v_id) if v_id.present? }

  validates :scheduled_date, presence: true
  validates :scheduled_time, presence: true
  validate :date_not_in_the_past
  validate :no_overlap_for_same_vehicle

  def status_name
    case status
    when "pending" then "Pendiente"
    when "confirmed" then "Confirmado"
    when "cancelled" then "Cancelado"
    else status.to_s.humanize
    end
  end

  def formatted_date
    scheduled_date&.strftime("%d/%m/%Y")
  end

  def formatted_time
    scheduled_time&.strftime("%H:%M hs")
  end

  private

  def date_not_in_the_past
    return if scheduled_date.blank?

    errors.add(:scheduled_date, "no puede ser en el pasado") if scheduled_date < Date.current
  end

  def no_overlap_for_same_vehicle
    return if vehicle_id.blank? || scheduled_date.blank? || scheduled_time.blank?

    overlapping = TestDrive.where(vehicle_id: vehicle_id, scheduled_date: scheduled_date,
                                   scheduled_time: scheduled_time)
                            .where.not(status: :cancelled)
                            .where.not(id: id)

    errors.add(:base, "Ya existe un test drive para ese vehículo en ese horario") if overlapping.exists?
  end
end
