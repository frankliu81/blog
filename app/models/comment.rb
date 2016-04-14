class Comment < ActiveRecord::Base
  # body must be present and unique per post once we have the foreign key post_id
  # validates :body, presence: true, uniqueness: {scope: :post_id}
  validates :body, presence: true
  
end
