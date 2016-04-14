FactoryGirl.define do
  factory :post do
    sequence(:title)  { |n| "#{Faker::Company.bs}-#{n}"}
    factory :post_with_body do
      body              { Faker::Hipster.paragraph }
    end
  end
end
