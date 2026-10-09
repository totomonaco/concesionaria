require "test_helper"

class VehicleModelTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "TestBrandForModel")
  end

  test "validates presence of name" do
    model = VehicleModel.new(brand: @brand, name: "")
    assert_not model.valid?
    assert_includes model.errors[:name], "no puede estar en blanco"
  end

  test "belongs to brand" do
    model = VehicleModel.create!(brand: @brand, name: "Civic Test")
    assert_equal @brand, model.brand
  end
end
