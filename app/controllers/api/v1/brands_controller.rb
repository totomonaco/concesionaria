module Api
  module V1
    class BrandsController < BaseController
      skip_before_action :authenticate_api_user!

      def index
        brands = Brand.order(:name)
        render json: brands.map { |b| { id: b.id, name: b.name } }
      end
    end
  end
end

