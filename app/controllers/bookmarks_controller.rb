class BookmarksController < ApplicationController
  before_action :require_login

  def index
    @bookmarked_scholarships = Scholarship.joins(:bookmarks)
                                        .where(bookmarks: { user_id: session[:user_id] })
  end

  def create
    @bookmark = Bookmark.new(
      user_id: session[:user_id],
      scholarship_id: params[:scholarship_id]
    )

    if @bookmark.save
      render json: { status: 'success' }
    else
      render json: { status: 'error', message: @bookmark.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @bookmark = Bookmark.find_by(
      user_id: session[:user_id],
      scholarship_id: params[:id]
    )

    if @bookmark&.destroy
      render json: { status: 'success' }
    else
      render json: { status: 'error' }, status: :unprocessable_entity
    end
  end

  private

  def require_login
    unless session[:user_id]
      redirect_to root_path, notice: "Please sign in first"
    end
  end
end
