FactoryGirl.define do
  factory :post do
    association :user, factory: :user
    association :category, factory: :category
    sequence(:title)  { |n| "#{Faker::Company.bs}-#{n}"}
    factory :post_with_body do

      body              { Faker::Hipster.paragraph }
    end
  end
end
