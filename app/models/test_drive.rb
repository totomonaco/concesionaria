class TestDrive < ApplicationRecord
  belongs_to :vehicle
  belongs_to :user

    enum :status, { pending: 0, confirmed: 1, cancelled: 2 }, default: :pending

  validates :scheduled_date, presence: true
  validates :scheduled_time, presence: true
  validate :date_not_in_the_past
  validate :no_overlap_for_same_vehicle

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
