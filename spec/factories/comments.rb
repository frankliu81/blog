FactoryGirl.define do
  factory :comment do
    # set up assocation in factory
    # if you don't pass in a user, it will create the user
    # using the factory user`
    # ensure a user is present
    association :user, factory: :user
    body      { Faker::Hipster.paragraph }
  end
end
