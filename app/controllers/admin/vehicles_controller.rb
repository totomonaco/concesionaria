module Admin
  class VehiclesController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_vehicle, only: %i[edit update destroy]

    def index
      @vehicles = Vehicle.includes(:vehicle_model).order(created_at: :desc)
    end

    def new
      @vehicle = Vehicle.new
    end

    def create
      @vehicle = Vehicle.new(vehicle_params)
      if @vehicle.save
        redirect_to admin_vehicles_path, notice: "Vehículo creado correctamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @vehicle.update(vehicle_params)
        redirect_to admin_vehicles_path, notice: "Vehículo actualizado"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @vehicle.destroy
      redirect_to admin_vehicles_path, notice: "Vehículo eliminado", status: :see_other
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def vehicle_params
      params.require(:vehicle).permit(:vehicle_model_id, :year, :price, :km, :used, :description)
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