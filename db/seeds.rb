# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  FactoryGirl.create(:category)
end

all_categories = Category.all
cateogories_count = all_categories.count
u = FactoryGirl.create(:user, password: 'bu', password_confirmation: 'bu')

10.times do
  p = FactoryGirl.create(:post_with_body)

  3.times do
    c = FactoryGirl.create(:comment)
    c.user = u
    p.comments.push(c)
  end

  random_category = all_categories.sample
  p.category = random_category
  p.user = u
  p.save

end

puts Cowsay.say "Generated 10 posts with 30 comments!"
