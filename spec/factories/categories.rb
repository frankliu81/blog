FactoryGirl.define do
  factory :category do
    sequence(:name) { |n| "#{Faker::Hacker.adjective}-#{n}"}
  end
end
