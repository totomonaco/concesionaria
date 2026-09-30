module Api
  module V1
    class TestDrivesController < BaseController
      def index
        test_drives = current_user.test_drives.includes(vehicle: { vehicle_model: :brand }).order(scheduled_at: :desc)
        render json: test_drives.map { |td| serialize_test_drive(td) }
      end

      def create
        vehicle = Vehicle.find_by(id: params[:vehicle_id])

        unless vehicle
          render json: { error: "Vehículo no encontrado" }, status: :not_found and return
        end

        if vehicle.sold?
          render json: { error: "El vehículo no está disponible para test drives" }, status: :unprocessable_entity and return
        end

        test_drive = current_user.test_drives.new(
          vehicle: vehicle,
          scheduled_at: params[:scheduled_at],
          notes: params[:notes]
        )

        if test_drive.save
          render json: serialize_test_drive(test_drive), status: :created
        else
          render json: { errors: test_drive.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def serialize_test_drive(td)
        {
          id: td.id,
          vehicle: "#{td.vehicle.vehicle_model.brand.name} #{td.vehicle.vehicle_model.name} (#{td.vehicle.year})",
          scheduled_at: td.scheduled_at,
          status: td.status,
          notes: td.notes
        }
      end
    end
  end
end
