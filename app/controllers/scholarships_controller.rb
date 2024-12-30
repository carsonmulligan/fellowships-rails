class ScholarshipsController < ApplicationController
  def index
    @scholarships = Scholarship.all
    @bookmarked_count = session[:user_id] ? Bookmark.where(user_id: session[:user_id]).count : 0
  end
end 