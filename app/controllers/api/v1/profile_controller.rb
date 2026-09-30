module Api
  module V1
    class ProfileController < BaseController
      def show
        render json: {
          id: current_user.id,
          name: current_user.name,
          email: current_user.email,
          role: current_user.role,
          test_drives_count: current_user.test_drives.count,
          appraisals_count: current_user.appraisals.count,
          purchases_count: current_user.sales_as_customer.count
        }
      end
    end
  end
end
