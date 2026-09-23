module Admin
  class VehicleModelsController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_vehicle_model, only: %i[edit update destroy]

    def index
      @vehicle_models = VehicleModel.includes(:brand).order("brands.name ASC, vehicle_models.name ASC")
    end

    def new
      @vehicle_model = VehicleModel.new
    end

    def create
      @vehicle_model = VehicleModel.new(vehicle_model_params)
      if @vehicle_model.save
        redirect_to admin_vehicle_models_path, notice: "Modelo creado correctamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @vehicle_model.update(vehicle_model_params)
        redirect_to admin_vehicle_models_path, notice: "Modelo actualizado correctamente"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @vehicle_model.destroy
      redirect_to admin_vehicle_models_path, notice: "Modelo eliminado", status: :see_other
    end

    private

    def set_vehicle_model
      @vehicle_model = VehicleModel.find(params[:id])
    end

    def vehicle_model_params
      params.require(:vehicle_model).permit(:name, :brand_id)
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
