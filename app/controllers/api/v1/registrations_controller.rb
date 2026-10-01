module Api
  module V1
    class RegistrationsController < BaseController
      skip_before_action :authenticate_api_user!

      def create
        user = User.new(registration_params)
        user.role = :customer

        if user.save
          render json: {
            token: user.api_token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          }, status: :created
        else
          render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
        end
      end

      private

      def registration_params
        params.permit(:name, :email, :password, :password_confirmation)
      end
    end
  end
end
