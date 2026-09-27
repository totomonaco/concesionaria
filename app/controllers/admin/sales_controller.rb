module Admin
  class SalesController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_sale, only: %i[show destroy]

    def index
      @sales = Sale.includes(:customer, :seller, vehicle: { vehicle_model: :brand }).recent_first
      @total_sales_count = @sales.count
      @total_ars = @sales.where(currency: "ars").sum(:price)
      @total_usd = @sales.where(currency: "usd").sum(:price)
    end

    def new
      @vehicle = Vehicle.find_by(id: params[:vehicle_id])
      if @vehicle&.sold?
        redirect_to admin_vehicles_path, alert: "El vehículo ya fue vendido anteriormente." and return
      end

      @sale = Sale.new(
        vehicle: @vehicle,
        price: @vehicle&.price,
        currency: @vehicle&.currency || "ars",
        sold_at: Date.current,
        payment_method: "cash"
      )
    end

    def create
      @sale = Sale.new(sale_params)
      @sale.seller = current_admin_user

      if params[:new_customer_email].present?
        customer = User.find_or_initialize_by(email: params[:new_customer_email].strip.downcase)
        if customer.new_record?
          customer.name = params[:new_customer_name].presence || "Cliente"
          customer.role = :customer
          customer.password = SecureRandom.hex(8)
          customer.save
        end
        @sale.customer = customer if customer.persisted?
      end

      if @sale.save
        redirect_to admin_sale_path(@sale), notice: "¡Venta registrada exitosamente! El vehículo fue marcado como Vendido."
      else
        @vehicle = @sale.vehicle
        render :new, status: :unprocessable_entity
      end
    end

    def show
    end

    def destroy
      vehicle_title = @sale.vehicle&.title
      @sale.destroy
      redirect_to admin_sales_path, notice: "La venta fue anulada. El vehículo #{vehicle_title} volvió a estar Disponible.", status: :see_other
    end

    private

    def set_sale
      @sale = Sale.includes(:customer, :seller, vehicle: { vehicle_model: :brand }).find(params[:id])
    end

    def sale_params
      params.require(:sale).permit(:vehicle_id, :customer_id, :price, :currency, :payment_method, :sold_at, :notes)
    end

    def current_admin_user
      @current_admin_user ||= User.find_by(id: session[:user_id])
    end
    helper_method :current_admin_user

    def require_seller!
      return if current_admin_user&.seller?

      redirect_to admin_login_path, alert: "Debés iniciar sesión como vendedor/admin."
    end
  end
end
