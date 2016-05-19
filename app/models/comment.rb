class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  # body must be present and unique per post once we have the foreign key post_id
  # validates :body, presence: true, uniqueness: {scope: :post_id}
  validates :body, presence: true

  def user_full_name
    user ? user.full_name : ""
  end

end
