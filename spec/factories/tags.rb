FactoryGirl.define do
  factory :tag do
    sequence(:name) { |n| "#{Faker::Hipster.word}-#{n}"}
  end
end
