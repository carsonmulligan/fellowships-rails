class ApplicationController < ActionController::Base
  before_action :verify_browser_support
  
  private

  def verify_browser_support
    # Allow all browsers for now
    true
  end
end
