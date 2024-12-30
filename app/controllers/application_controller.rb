class ApplicationController < ActionController::Base
  # Allow all browsers while maintaining security
  skip_before_action :verify_browser_support, if: -> { request.format.json? }
  allow_browser versions: :modern, except: %w[bookmarks scholarships]
end
