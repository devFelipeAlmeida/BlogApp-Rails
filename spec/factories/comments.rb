FactoryBot.define do
  factory :comment do
    message { 'Este é um comentário de exemplo.' }
    association :post
    association :user
  end
end
