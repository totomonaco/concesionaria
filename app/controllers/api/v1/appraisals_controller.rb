module Api
  module V1
    class AppraisalsController < BaseController
      def index
        appraisals = current_user.appraisals.order(created_at: :desc)
        render json: appraisals.map { |a| serialize(a) }
      end

      def create
        appraisal = current_user.appraisals.new(appraisal_params)

        if appraisal.save
          render json: serialize(appraisal), status: :created
        else
          render json: { errors: appraisal.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def appraisal_params
        params.permit(:make, :car_model, :year, :km, :description, :photo)
      end

      def serialize(appraisal)
        {
          id: appraisal.id,
          car: appraisal.car_title,
          km: appraisal.km,
          description: appraisal.description,
          status: appraisal.status,
          status_name: appraisal.status_name,
          quoted_price: appraisal.quoted_price,
          admin_notes: appraisal.admin_notes,
          created_at: appraisal.created_at.strftime("%d/%m/%Y")
        }
      end
    end
  end
end
