class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :post

  # combination of user_id and post_id
  validates :user_id, uniqueness: {scope: :post_id}

end
