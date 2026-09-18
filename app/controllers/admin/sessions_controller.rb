module Admin
  class SessionsController < ApplicationController
    def new
    end

    def create
      user = User.find_by(email: params[:email])
      if user&.authenticate(params[:password]) && user.seller?
        session[:user_id] = user.id
        redirect_to admin_root_path, notice: "Bienvenido #{user.name}"
      else
        @error = "Credenciales inválidas o el usuario no es vendedor/admin"
        render :new, status: :unprocessable_entity
      end
    end

    def destroy
      session[:user_id] = nil
      redirect_to admin_login_path, notice: "Sesión cerrada"
    end
  end
end