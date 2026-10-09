require "test_helper"

class ApiV1Test < ActionDispatch::IntegrationTest
  setup do
    @brand = Brand.create!(name: "ApiBrand")
    @model = VehicleModel.create!(brand: @brand, name: "ApiModel")
    @vehicle = Vehicle.create!(
      vehicle_model: @model,
      year: 2023,
      price: 20000000,
      currency: "ars",
      condition: "used",
      km: 15000,
      status: :available
    )
  end

  test "public vehicles catalog and detail" do
    get "/api/v1/vehicles"
    assert_response :success
    json = JSON.parse(response.body)
    assert json.is_a?(Array)
    assert json.any? { |v| v["id"] == @vehicle.id }

    get "/api/v1/vehicles/#{@vehicle.id}"
    assert_response :success
    detail = JSON.parse(response.body)
    assert_equal @vehicle.id, detail["id"]
    assert_equal "ApiBrand", detail["brand"]
    assert_equal "ApiModel", detail["model"]
  end

  test "user registration, login, and profile" do
    post "/api/v1/registrations", params: {
      name: "Nuevo Cliente API",
      email: "cliente_api@example.com",
      password: "password123",
      password_confirmation: "password123"
    }, as: :json
    assert_response :created
    reg_json = JSON.parse(response.body)
    token = reg_json["token"]
    assert_not_nil token

    # Check profile
    get "/api/v1/profile", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success
    profile_json = JSON.parse(response.body)
    assert_equal "cliente_api@example.com", profile_json["email"]

    # Unauthorized access without token
    get "/api/v1/profile"
    assert_response :unauthorized
  end

  test "request test drive via API" do
    user = User.create!(name: "TD Api User", email: "td_api@example.com", password: "password123")
    token = user.api_token

    assert_emails 1 do
      post "/api/v1/test_drives", params: {
        vehicle_id: @vehicle.id,
        scheduled_at: (Date.current + 2.days).to_s + "T10:00:00"
      }, headers: { "Authorization" => "Bearer #{token}" }, as: :json
    end

    assert_response :created
    td_json = JSON.parse(response.body)
    assert_equal "Pendiente", td_json["status_name"]

    # List user's test drives
    get "/api/v1/test_drives", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success
    list = JSON.parse(response.body)
    assert_equal 1, list.length
  end

  test "submit appraisal via API" do
    user = User.create!(name: "Appraisal Api User", email: "appraisal_api@example.com", password: "password123")
    token = user.api_token

    assert_emails 1 do
      post "/api/v1/appraisals", params: {
        make: "Chevrolet",
        car_model: "Onix",
        year: 2021,
        km: 40000,
        description: "Excelente estado"
      }, headers: { "Authorization" => "Bearer #{token}" }, as: :json
    end

    assert_response :created
    app_json = JSON.parse(response.body)
    assert_equal "Pendiente", app_json["status_name"]

    # List appraisals
    get "/api/v1/appraisals", headers: { "Authorization" => "Bearer #{token}" }
    assert_response :success
    list = JSON.parse(response.body)
    assert_equal 1, list.length
  end
end
