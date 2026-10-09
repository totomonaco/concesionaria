require "test_helper"

class AppraisalMailerTest < ActionMailer::TestCase
  setup do
    @user = User.create!(name: "Usuario Tasacion", email: "tasacion_mail@example.com", password: "password123")
    @appraisal = Appraisal.create!(
      user: @user,
      make: "Ford",
      car_model: "Focus",
      year: 2018,
      km: 65000,
      description: "Excelente estado"
    )
  end

  test "received_email" do
    email = AppraisalMailer.received_email(@appraisal)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @user.email ], email.to
    assert_includes email.subject, "Solicitud de tasación recibida"
    decoded_text = email.text_part.body.decoded
    assert_includes decoded_text, @appraisal.car_title
  end

  test "quoted_email" do
    @appraisal.update!(quoted_price: 18000000, status: "quoted", admin_notes: "Precio fijado según estado general")
    email = AppraisalMailer.quoted_email(@appraisal)

    assert_emails 1 do
      email.deliver_now
    end

    assert_equal [ @user.email ], email.to
    assert_includes email.subject, "¡Tu cotización está lista!"
    decoded_text = email.text_part.body.decoded
    assert_includes decoded_text, "18,000,000"
    assert_includes decoded_text, "Precio fijado según estado general"
  end
end
