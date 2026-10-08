class AppraisalsController < ApplicationController
  def new
    @appraisal = Appraisal.new
  end

  def create
    customer_email = params[:customer_email].to_s.strip.downcase
    customer_name = params[:customer_name].to_s.strip

    user = User.find_by(id: session[:user_id])
    if user.nil? && customer_email.present?
      user = User.find_or_initialize_by(email: customer_email)
      if user.new_record?
        user.name = customer_name.presence || "Cliente"
        user.role = :customer
        user.password = SecureRandom.hex(8)
        user.save
      end
    end

    @appraisal = Appraisal.new(appraisal_params)
    @appraisal.user = user

    if @appraisal.save
      AppraisalMailer.received_email(@appraisal).deliver_later if @appraisal.user&.email.present?
      redirect_to appraisal_path(@appraisal), notice: "¡Tu solicitud fue enviada! Te contactaremos con la cotización."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @appraisal = Appraisal.find(params[:id])
  end

  private

  def appraisal_params
    params.require(:appraisal).permit(:make, :car_model, :year, :km, :description, :photo)
  end
end
