require "test_helper"

class BrandTest < ActiveSupport::TestCase
  test "validates presence of name" do
    brand = Brand.new(name: "")
    assert_not brand.valid?
    assert_includes brand.errors[:name], "no puede estar en blanco"
  end

  test "validates uniqueness of name" do
    Brand.create!(name: "TestUniqBrand")
    duplicate = Brand.new(name: "TestUniqBrand")
    assert_not duplicate.valid?
    assert_includes duplicate.errors[:name], "ya existe"
  end

  test "has many vehicle models and destroys them on delete" do
    brand = Brand.create!(name: "BrandWithModels")
    brand.vehicle_models.create!(name: "ModelX")
    assert_difference "VehicleModel.count", -1 do
      brand.destroy
    end
  end
end
