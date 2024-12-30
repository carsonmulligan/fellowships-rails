module PremiumHelper
  def premium_user?
    user_signed_in? && current_user.premium?
  end

  def require_premium
    unless premium_user?
      store_location_for(:user, request.fullpath)
      redirect_to root_path, alert: 'This feature requires a Fellows membership.'
    end
  end
end 