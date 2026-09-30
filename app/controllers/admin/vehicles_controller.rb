module Admin
  class VehiclesController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_vehicle, only: %i[edit update destroy purge_photo]

    def index
      @vehicles = Vehicle.includes({ vehicle_model: :brand }, :test_drives, :sale, photos_attachments: :blob).order(created_at: :desc)
    end

    def new
      @vehicle = Vehicle.new
    end

    def create
      new_photos = extract_clean_photos
      @vehicle = Vehicle.new(vehicle_params.except(:photos))
      @vehicle.photos.attach(new_photos) if new_photos.any?

      if @vehicle.save
        redirect_to admin_vehicles_path, notice: "Vehículo creado correctamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      new_photos = extract_clean_photos
      @vehicle.photos.attach(new_photos) if new_photos.any?

      if @vehicle.update(vehicle_params.except(:photos))
        redirect_to admin_vehicles_path, notice: "Vehículo actualizado"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def purge_photo
      photo = @vehicle.photos.find_by(id: params[:photo_id])
      photo&.purge
      redirect_to edit_admin_vehicle_path(@vehicle), notice: "Foto eliminada"
    end

    def destroy
      @vehicle.destroy
      redirect_to admin_vehicles_path, notice: "Vehículo eliminado", status: :see_other
    end

    private

    def set_vehicle
      @vehicle = Vehicle.find(params[:id])
    end

    def extract_clean_photos
      raw = params.dig(:vehicle, :photos)
      Array(raw).select do |photo|
        photo.respond_to?(:tempfile) && photo.original_filename.present? && photo.size.to_i > 0
      end
    end

    def vehicle_params
      params.require(:vehicle).permit(:vehicle_model_id, :year, :price, :currency, :km, :used, :description, photos: [])
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