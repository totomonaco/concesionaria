module Admin
  class TestDrivesController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_test_drive, only: %i[edit update destroy confirm cancel]

    def index
      @status = params[:status].presence || "all"
      @vehicle_id = params[:vehicle_id].presence

      @test_drives = TestDrive.includes(:user, vehicle: { vehicle_model: :brand }).recent_first
      @test_drives = @test_drives.by_status(@status) if @status != "all"
      @test_drives = @test_drives.for_vehicle(@vehicle_id) if @vehicle_id.present?

      @pending_count = TestDrive.pending.count
    end

    def new
      @test_drive = TestDrive.new(
        vehicle_id: params[:vehicle_id],
        scheduled_date: Date.current,
        scheduled_time: Time.zone.parse("10:00")
      )
    end

    def create
      @test_drive = TestDrive.new(test_drive_params)

      if params[:new_customer_email].present?
        customer = User.find_or_initialize_by(email: params[:new_customer_email].strip.downcase)
        if customer.new_record?
          customer.name = params[:new_customer_name].presence || "Cliente"
          customer.role = :customer
          customer.password = SecureRandom.hex(8)
          customer.save
        end
        @test_drive.user = customer if customer.persisted?
      end

      if @test_drive.save
        redirect_to admin_test_drives_path, notice: "Test Drive agendado correctamente."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @test_drive.update(test_drive_params)
        redirect_to admin_test_drives_path, notice: "Test Drive actualizado correctamente."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @test_drive.destroy
      redirect_to admin_test_drives_path, notice: "Test Drive eliminado.", status: :see_other
    end

    def confirm
      if @test_drive.confirmed!
        redirect_to admin_test_drives_path(status: params[:current_status]), notice: "Test Drive ##{@test_drive.id} confirmado."
      else
        redirect_to admin_test_drives_path, alert: "No se pudo confirmar el Test Drive."
      end
    end

    def cancel
      if @test_drive.cancelled!
        redirect_to admin_test_drives_path(status: params[:current_status]), notice: "Test Drive ##{@test_drive.id} cancelado."
      else
        redirect_to admin_test_drives_path, alert: "No se pudo cancelar el Test Drive."
      end
    end

    private

    def set_test_drive
      @test_drive = TestDrive.find(params[:id])
    end

    def test_drive_params
      params.require(:test_drive).permit(:vehicle_id, :user_id, :scheduled_date, :scheduled_time, :status)
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
