module Api
  module V1
    class VehiclesController < BaseController
      skip_before_action :authenticate_api_user!

      def index
        vehicles = Vehicle.available_for_sale
                          .includes({ vehicle_model: :brand }, photos_attachments: :blob)
                          .by_condition(params[:condition])
                          .by_brand(params[:brand_id])
                          .by_price(params[:sort])

        render json: vehicles.map { |v| serialize_vehicle(v) }
      end

      def show
        vehicle = Vehicle.includes({ vehicle_model: :brand }, photos_attachments: :blob).find_by(id: params[:id])

        if vehicle
          render json: serialize_vehicle(vehicle, detailed: true)
        else
          render json: { error: "Vehículo no encontrado" }, status: :not_found
        end
      end

      private

      def serialize_vehicle(vehicle, detailed: false)
        first_photo = vehicle.photos.first if vehicle.photos.attached?
        cover_url = first_photo ? Rails.application.routes.url_helpers.rails_blob_url(first_photo, only_path: true) : nil
        photo_urls = vehicle.photos.attached? ? vehicle.photos.map { |p| Rails.application.routes.url_helpers.rails_blob_url(p, only_path: true) } : []

        data = {
          id: vehicle.id,
          brand: vehicle.vehicle_model.brand.name,
          model: vehicle.vehicle_model.name,
          year: vehicle.year,
          km: vehicle.km,
          condition: vehicle.condition,
          price: vehicle.price,
          currency: vehicle.currency,
          formatted_price: vehicle.formatted_price,
          status: vehicle.status,
          cover_photo: cover_url,
          photos: photo_urls
        }

        if detailed
          data[:color] = vehicle.color if vehicle.respond_to?(:color)
          data[:description] = vehicle.description if vehicle.respond_to?(:description)
        end

        data
      end
    end
  end
end
