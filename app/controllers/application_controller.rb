class ApplicationController < ActionController::Base
  # Allow all browsers while maintaining security
  allow_browser versions: :modern, except: %w[bookmarks scholarships]
  skip_after_action :verify_browser_support, if: -> { request.format.json? }
end
