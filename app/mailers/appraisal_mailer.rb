class AppraisalMailer < ApplicationMailer
  def received_email(appraisal)
    @appraisal = appraisal
    @user = appraisal.user
    recipient_email = @user&.email
    return if recipient_email.blank?

    mail(
      to: recipient_email,
      subject: "Solicitud de tasación recibida - #{@appraisal.car_title}"
    )
  end

  def quoted_email(appraisal)
    @appraisal = appraisal
    @user = appraisal.user
    recipient_email = @user&.email
    return if recipient_email.blank?

    mail(
      to: recipient_email,
      subject: "¡Tu cotización está lista! - #{@appraisal.car_title}"
    )
  end
end
