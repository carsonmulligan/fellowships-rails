class BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
  allow_browser versions: :all

  before_action :require_login

  def index
    @bookmarked_scholarships = Scholarship.joins(:bookmarks)
                                      .where(bookmarks: { user_id: current_user.id })
  end

  def create
    @bookmark = Bookmark.new(
      user_id: current_user.id,
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
      user_id: current_user.id,
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
    unless current_user
      redirect_to root_path, notice: "Please sign in first"
    end
  end
end
