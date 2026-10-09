require "test_helper"

class TestDriveMailerTest < ActionMailer::TestCase
  setup do
    @brand = Brand.create!(name: "MailBrand")
    @model = VehicleModel.create!(brand: @brand, name: "MailModel")
    @vehicle = Vehicle.create!(vehicle_model: @model, year: 2022, price: 15000000, km: 10000)
    @user = User.create!(name: "Usuario Mail", email: "user_mail@example.com", password: "password123")
    @test_drive = TestDrive.create!(
      vehicle: @vehicle,
      user: @user,
      scheduled_date: Date.current + 2.days,
      scheduled_time: Time.zone.parse("14:00")
    )
  end

  test "confirmation_email" do
    email = TestDriveMailer.confirmation_email(@test_drive)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @user.email ], email.to
    assert_includes email.subject, "Solicitud de Test Drive recibida"
    decoded_text = email.text_part.body.decoded
    assert_includes decoded_text, @vehicle.title
    assert_includes decoded_text, @user.name
  end

  test "status_update_email" do
    @test_drive.confirmed!
    email = TestDriveMailer.status_update_email(@test_drive)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @user.email ], email.to
    assert_includes email.subject, "Actualización de tu Test Drive"
    decoded_text = email.text_part.body.decoded
    assert_includes decoded_text, "Confirmado"
  end
end
