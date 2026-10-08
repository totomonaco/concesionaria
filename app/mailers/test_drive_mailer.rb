class TestDriveMailer < ApplicationMailer
  def confirmation_email(test_drive)
    @test_drive = test_drive
    @user = test_drive.user
    @vehicle = test_drive.vehicle

    mail(
      to: @user.email,
      subject: "Solicitud de Test Drive recibida - #{@vehicle.title}"
    )
  end

  def status_update_email(test_drive)
    @test_drive = test_drive
    @user = test_drive.user
    @vehicle = test_drive.vehicle

    mail(
      to: @user.email,
      subject: "Actualización de tu Test Drive - #{@vehicle.title} (#{@test_drive.status_name})"
    )
  end
end
