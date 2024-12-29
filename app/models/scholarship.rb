class Scholarship < ApplicationRecord
  def self.tag_counts
    pluck(:tags).flatten.group_by(&:itself).transform_values(&:count)
  end

  def self.by_tag(tag)
    where("? = ANY (tags)", tag)
  end
end
