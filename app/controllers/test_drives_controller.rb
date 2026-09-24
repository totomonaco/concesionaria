class TestDrivesController < ApplicationController
  def new
    @vehicle = Vehicle.find_by(id: params[:vehicle_id])
    @test_drive = TestDrive.new(
      vehicle: @vehicle,
      scheduled_date: Date.current + 1.day,
      scheduled_time: Time.zone.parse("10:00")
    )
  end

  def create
    @vehicle = Vehicle.find_by(id: params[:test_drive][:vehicle_id])
    customer_email = params[:customer_email].to_s.strip.downcase
    customer_name = params[:customer_name].to_s.strip

    if customer_email.blank? || customer_name.blank?
      @test_drive = TestDrive.new(test_drive_params)
      @test_drive.errors.add(:base, "Nombre y email del cliente son obligatorios")
      render :new, status: :unprocessable_entity and return
    end

    customer = User.find_or_initialize_by(email: customer_email)
    if customer.new_record?
      customer.name = customer_name
      customer.role = :customer
      customer.password = SecureRandom.hex(8)
      unless customer.save
        @test_drive = TestDrive.new(test_drive_params)
        customer.errors.full_messages.each { |m| @test_drive.errors.add(:base, m) }
        render :new, status: :unprocessable_entity and return
      end
    end

    @test_drive = TestDrive.new(test_drive_params)
    @test_drive.user = customer
    @test_drive.status = :pending

    if @test_drive.save
      redirect_to test_drive_path(@test_drive), notice: "¡Tu solicitud de Test Drive fue enviada con éxito! Nos contactaremos a la brevedad."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @test_drive = TestDrive.includes(:user, vehicle: { vehicle_model: :brand }).find(params[:id])
  end

  private

  def test_drive_params
    params.require(:test_drive).permit(:vehicle_id, :scheduled_date, :scheduled_time)
  end
end
