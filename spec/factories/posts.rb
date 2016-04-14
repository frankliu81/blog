FactoryGirl.define do
  factory :post do
    sequence(:title)  { |n| "#{Fake::Company.bs}-#{n}"}
    body              { Faker::Hipster.paragraph }
  end
end
