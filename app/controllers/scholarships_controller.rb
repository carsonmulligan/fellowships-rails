class ScholarshipsController < ApplicationController
  def index
    @scholarships = if params[:tag]
      Scholarship.by_tag(params[:tag])
    else
      Scholarship.all
    end

    @bookmarked_count = session[:user_id] ? Bookmark.where(user_id: session[:user_id]).count : 0
  end
end 