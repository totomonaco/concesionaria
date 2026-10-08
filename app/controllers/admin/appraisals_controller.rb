module Admin
  class AppraisalsController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_appraisal, only: %i[show update]

    def index
      @appraisals = Appraisal.includes(:user).pending_first
    end

    def show
    end

    def update
      previously_quoted = @appraisal.quoted?
      if @appraisal.update(appraisal_admin_params)
        if @appraisal.quoted? && (!previously_quoted || @appraisal.saved_change_to_quoted_price?)
          AppraisalMailer.quoted_email(@appraisal).deliver_later if @appraisal.user&.email.present?
        end
        redirect_to admin_appraisal_path(@appraisal), notice: "Tasación actualizada correctamente."
      else
        render :show, status: :unprocessable_entity
      end
    end

    private

    def set_appraisal
      @appraisal = Appraisal.find(params[:id])
    end

    def appraisal_admin_params
      params.require(:appraisal).permit(:quoted_price, :status, :admin_notes)
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
