require "test_helper"

class TestDriveTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "TDBrand")
    @model = VehicleModel.create!(brand: @brand, name: "TDModel")
    @vehicle = Vehicle.create!(vehicle_model: @model, year: 2021, price: 10000000, km: 10000)
    @customer = User.create!(name: "Cliente TD", email: "client_td@example.com", password: "password123", role: :customer)
  end

  test "valid test drive defaults to pending" do
    td = TestDrive.create!(
      vehicle: @vehicle,
      user: @customer,
      scheduled_date: Date.current + 1.day,
      scheduled_time: Time.zone.parse("15:00")
    )
    assert td.persisted?
    assert td.pending?
    assert_equal "Pendiente", td.status_name
  end

  test "transitions to confirmed and cancelled" do
    td = TestDrive.create!(
      vehicle: @vehicle,
      user: @customer,
      scheduled_date: Date.current + 1.day,
      scheduled_time: Time.zone.parse("15:00")
    )

    td.confirmed!
    assert td.confirmed?
    assert_equal "Confirmado", td.status_name

    td.cancelled!
    assert td.cancelled?
    assert_equal "Cancelado", td.status_name
  end
end
