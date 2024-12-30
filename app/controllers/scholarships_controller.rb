class ScholarshipsController < ApplicationController
  def index
    @scholarships = Scholarship.all
    @bookmarked_count = current_user ? Bookmark.where(user_id: current_user.id).count : 0
  end

  def show
    @scholarship = Scholarship.find(params[:id])
    @is_bookmarked = current_user && Bookmark.exists?(user_id: current_user.id, scholarship_id: @scholarship.id)
  end
end 