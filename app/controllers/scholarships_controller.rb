class ScholarshipsController < ApplicationController
  def index
    @scholarships = Scholarship.all
    @bookmarked_count = current_user ? Bookmark.where(user_id: current_user.id).count : 0

    # Add filter logic
    if params[:filter] == 'bookmarked' && current_user
      @scholarships = @scholarships.joins(:bookmarks)
                                 .where(bookmarks: { user_id: current_user.id })
    end
  end

  def show
    @scholarship = Scholarship.find(params[:id])
    @is_bookmarked = current_user && Bookmark.exists?(user_id: current_user.id, scholarship_id: @scholarship.id)
  end
end 