module PremiumHelper
  def premium_user?
    user_signed_in?  # All logged-in users are premium users
  end

  def require_premium
    unless user_signed_in?
      store_location_for(:user, request.fullpath)
      redirect_to root_path, alert: 'This feature requires a Fellows membership.'
    end
  end
end 