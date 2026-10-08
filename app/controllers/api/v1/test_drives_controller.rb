module Api
  module V1
    class TestDrivesController < BaseController
      def index
        test_drives = current_user.test_drives.includes(vehicle: { vehicle_model: :brand }).recent_first
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

        scheduled_date = params[:scheduled_date]
        scheduled_time = params[:scheduled_time]

        if params[:scheduled_at].present?
          parsed = Time.zone.parse(params[:scheduled_at].to_s)
          scheduled_date ||= parsed&.to_date
          scheduled_time ||= parsed
        end

        test_drive = current_user.test_drives.new(
          vehicle: vehicle,
          scheduled_date: scheduled_date,
          scheduled_time: scheduled_time
        )

        if test_drive.save
          TestDriveMailer.confirmation_email(test_drive).deliver_later
          render json: serialize_test_drive(test_drive), status: :created
        else
          render json: { errors: test_drive.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def serialize_test_drive(td)
        {
          id: td.id,
          vehicle: td.vehicle.title,
          scheduled_date: td.formatted_date,
          scheduled_time: td.formatted_time,
          status: td.status,
          status_name: td.status_name
        }
      end
    end
  end
end
