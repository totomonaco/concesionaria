module Api
  module V1
    class SessionsController < BaseController
      skip_before_action :authenticate_api_user!

      def create
        user = User.find_by(email: params[:email]&.downcase&.strip)

        if user&.authenticate(params[:password])
          user.regenerate_api_token!
          render json: {
            token: user.api_token,
            user: {
              id: user.id,
              name: user.name,
              email: user.email,
              role: user.role
            }
          }, status: :ok
        else
          render json: { error: "Email o contraseña incorrectos" }, status: :unauthorized
        end
      end

      def destroy
        token = request.headers["Authorization"]&.split("Bearer ")&.last
        user = User.find_by(api_token: token)
        user&.invalidate_api_token!
        render json: { message: "Sesión cerrada correctamente" }, status: :ok
      end
    end
  end
end
