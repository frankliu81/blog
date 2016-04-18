FactoryGirl.define do
  factory :comment do
    body      { Faker::Hipster.paragraph }
  end
end
