class AppraisalsController < ApplicationController
  def new
    @appraisal = Appraisal.new
  end

  def create
    @appraisal = Appraisal.new(appraisal_params)
    @appraisal.user = User.find_by(id: session[:user_id])

    if @appraisal.save
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
