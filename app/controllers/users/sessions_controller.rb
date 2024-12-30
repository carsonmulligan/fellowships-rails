module Users
  class SessionsController < Devise::SessionsController
    def after_sign_out_path_for(_resource_or_scope)
      root_path
    end

    def after_sign_in_path_for(resource_or_scope)
      stored_location_for(resource_or_scope) || root_path
    end

    def new
      if request.xhr? || request.format.json?
        render json: { redirect_to_modal: true }, status: :ok
      else
        session[:show_premium_modal] = true
        redirect_to root_path
      end
    end

    def create
      super
    end

    def destroy
      super
    end
  end
end 