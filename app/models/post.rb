class Post < ActiveRecord::Base
  # title must be present and unique
  validates :title, presence: true, uniqueness: true

end
