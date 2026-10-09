require "test_helper"

class VehicleTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "TestBrandVeh")
    @model = VehicleModel.create!(brand: @brand, name: "TestModelVeh")
  end

  test "validates required attributes" do
    vehicle = Vehicle.new
    assert_not vehicle.valid?
    assert vehicle.errors[:vehicle_model].any?
    assert vehicle.errors[:year].any?
    assert vehicle.errors[:price].any?
  end

  test "creates valid vehicle and defaults to available status" do
    vehicle = Vehicle.new(
      vehicle_model: @model,
      year: 2022,
      price: 15000000,
      currency: "ars",
      km: 25000,
      condition: "used"
    )
    assert vehicle.valid?
    assert vehicle.available?
  end

  test "available_for_sale scope filters out sold vehicles" do
    v1 = Vehicle.create!(vehicle_model: @model, year: 2021, price: 10000000, km: 10000, status: :available)
    v2 = Vehicle.create!(vehicle_model: @model, year: 2022, price: 12000000, km: 20000, status: :reserved)
    v3 = Vehicle.create!(vehicle_model: @model, year: 2023, price: 14000000, km: 30000, status: :sold)

    available = Vehicle.available_for_sale
    assert_includes available, v1
    assert_includes available, v2
    assert_not_includes available, v3
  end

  test "title and formatted_price helpers" do
    vehicle = Vehicle.new(
      vehicle_model: @model,
      year: 2020,
      price: 20000000,
      currency: "ars"
    )
    assert_equal "TestBrandVeh TestModelVeh (2020)", vehicle.title
    assert_includes vehicle.formatted_price, "ARS"
  end
end
