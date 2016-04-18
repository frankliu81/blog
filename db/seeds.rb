# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do
  p = FactoryGirl.create(:post_with_body)

  3.times do
    c = FactoryGirl.create(:comment)
    p.comments.push(c)

  end
end

puts Cowsay.say "Generated 10 posts with 30 comments!"
