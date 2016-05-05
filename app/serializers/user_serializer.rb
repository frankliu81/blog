class UserSerializer < ActiveModel::Serializer
  attributes :first_name, :last_name, :full_name
end
