module Admin
  class BrandsController < ApplicationController
    layout "admin"
    before_action :require_seller!
    before_action :set_brand, only: %i[edit update destroy]

    def index
      @brands = Brand.order(:name)
    end

    def new
      @brand = Brand.new
    end

    def create
      @brand = Brand.new(brand_params)
      if @brand.save
        redirect_to admin_brands_path, notice: "Marca creada correctamente"
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
    end

    def update
      if @brand.update(brand_params)
        redirect_to admin_brands_path, notice: "Marca actualizada correctamente"
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @brand.destroy
      redirect_to admin_brands_path, notice: "Marca eliminada", status: :see_other
    end

    private

    def set_brand
      @brand = Brand.find(params[:id])
    end

    def brand_params
      params.require(:brand).permit(:name)
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
