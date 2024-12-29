class ScholarshipsController < ApplicationController
  def index
    @scholarships = if params[:tag]
      Scholarship.by_tag(params[:tag])
    else
      Scholarship.all
    end
  end
end 