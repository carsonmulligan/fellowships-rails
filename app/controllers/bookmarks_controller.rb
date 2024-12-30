class BookmarksController < ApplicationController
  skip_before_action :verify_authenticity_token, only: [:create, :destroy]
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

    respond_to do |format|
      if @bookmark.save
        format.json { render json: { status: 'success' }, status: :ok }
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.json { render json: { status: 'error', message: @bookmark.errors.full_messages }, status: :unprocessable_entity }
        format.html { redirect_back(fallback_location: root_path, alert: @bookmark.errors.full_messages.join(", ")) }
      end
    end
  end

  def destroy
    @bookmark = Bookmark.find_by(
      user_id: current_user.id,
      scholarship_id: params[:id]
    )

    respond_to do |format|
      if @bookmark&.destroy
        format.json { render json: { status: 'success' }, status: :ok }
        format.html { redirect_back(fallback_location: root_path) }
      else
        format.json { render json: { status: 'error' }, status: :unprocessable_entity }
        format.html { redirect_back(fallback_location: root_path, alert: "Unable to remove bookmark") }
      end
    end
  end

  private

  def require_login
    unless current_user
      respond_to do |format|
        format.json { render json: { status: 'error', message: 'Please sign in first' }, status: :unauthorized }
        format.html { redirect_to root_path, notice: "Please sign in first" }
      end
    end
  end
end
