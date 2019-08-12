FactoryBot.define do
  factory :answer do
    body { "BotAnswer" }

    question
    user

    trait :invalid do
      body { nil }
    end
  end
end
