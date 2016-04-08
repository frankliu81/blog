class Comment < ActiveRecord::Base
  # body must be present and unique per post
  validates :body, presence: true, uniqueness: {scope: :post_id}
end
