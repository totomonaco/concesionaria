require "test_helper"

class SaleTest < ActiveSupport::TestCase
  setup do
    @brand = Brand.create!(name: "SaleBrand")
    @model = VehicleModel.create!(brand: @brand, name: "SaleModel")
    @vehicle = Vehicle.create!(vehicle_model: @model, year: 2021, price: 10000000, km: 10000)
    @customer = User.create!(name: "Cliente Sale", email: "client_sale@example.com", password: "password123", role: :customer)
    @seller = User.create!(name: "Vendedor Sale", email: "seller_sale@example.com", password: "password123", role: :seller)
  end

  test "valid sale marks vehicle as sold" do
    assert @vehicle.available?

    sale = Sale.create!(
      vehicle: @vehicle,
      customer: @customer,
      seller: @seller,
      price: 9500000,
      currency: "ars",
      payment_method: "cash",
      sold_at: Date.current
    )

    assert sale.persisted?
    @vehicle.reload
    assert @vehicle.sold?
  end
end
