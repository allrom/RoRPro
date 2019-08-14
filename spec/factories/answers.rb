FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "BotAnswer_#{n}" }

    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
