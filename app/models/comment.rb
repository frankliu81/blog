class Comment < ActiveRecord::Base
  belongs_to :post

  # body must be present and unique per post once we have the foreign key post_id
  # validates :body, presence: true, uniqueness: {scope: :post_id}
  validates :body, presence: true

end
