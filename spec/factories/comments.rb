FactoryBot.define do
  factory :comment do
    message { Faker::Lorem.sentence }
    association :post
    association :user
  end
end
