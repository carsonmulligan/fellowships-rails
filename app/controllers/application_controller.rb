class ApplicationController < ActionController::Base
  # Allow modern browsers, but exclude validation for specific controllers
  allow_browser versions: :modern
end
