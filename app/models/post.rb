class Post < ActiveRecord::Base
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

  # before_validation are hooks
  before_validation :titleize_title

  private

  def titleize_title
    if title
      self.title = title.titleize
    end
  end

end
