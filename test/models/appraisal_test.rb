require "test_helper"

class AppraisalTest < ActiveSupport::TestCase
  test "validates required fields" do
    appraisal = Appraisal.new
    assert_not appraisal.valid?
    assert appraisal.errors[:make].any?
    assert appraisal.errors[:car_model].any?
    assert appraisal.errors[:year].any?
    assert appraisal.errors[:km].any?
  end

  test "valid appraisal defaults to pending" do
    appraisal = Appraisal.create!(
      make: "Toyota",
      car_model: "Yaris",
      year: 2020,
      km: 30000,
      description: "Excelente estado"
    )
    assert appraisal.persisted?
    assert_equal "pending", appraisal.status
    assert_equal "Pendiente", appraisal.status_name
    assert_equal "Toyota Yaris (2020)", appraisal.car_title
  end
end
