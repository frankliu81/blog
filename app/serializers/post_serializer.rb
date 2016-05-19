class PostSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :tag_names, :user_full_name
  has_many :comments
  #belongs_to :category
  # belongs_to :user

  def tag_names
    # only return the name from the associated tag object
    object.tags.map(&:name)
  end

  def user
    # user will be serialized with the user_serializer
    object.user
  end

  def user_full_name
    user.full_name
  end

  def like_count
    
  end

end
