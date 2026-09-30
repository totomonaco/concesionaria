module Api
  module V1
    class BaseController < ApplicationController
      skip_before_action :verify_authenticity_token
      before_action :authenticate_api_user!, except: :index

      private

      def authenticate_api_user!
        token = request.headers["Authorization"]&.split("Bearer ")&.last
        @current_user = User.find_by(api_token: token)
        render json: { error: "No autorizado" }, status: :unauthorized unless @current_user
      end

      def current_user
        @current_user
      end
    end
  end
end
