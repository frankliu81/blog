class Post < ActiveRecord::Base
  has_many :comments, dependent: :destroy
  belongs_to :category
  belongs_to :user

  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :users

  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings

  # before_validation are hooks
  before_validation :titleize_title

  # title must be present and unique
  validates :title, presence: true, uniqueness: true

  # validates :title, length: { minimum: 7,
  #   too_short: "Title needs to be at least 7 characters long." }

  # syntax error if there is a space between validates and ()
 validates(:title, length: { minimum: 7,
   too_short: "Title needs to be at least 7 characters long." })


  validates :body, presence: true

  def body_snippet
    if body.length > 100
      return body[0..99] + "..."
    else
      return body
    end
  end

  def user_full_name
    user ? user.full_name : ""
  end

  def favorite_for(user)
    favorites.find_by_user_id user if user
  end

  def titleize_title
    if title
      self.title = title.titleize
    end
  end

  def self.search(search_term)
  #where(["name ILIKE? OR email ILIKE?", "%#{search_term}%", "%#{search_term}%"])
    # what if you want the search to include the association like category and username
    where(["title ILIKE :term OR body ILIKE :term", {term: "%#{search_term}%"} ])
  end


end
