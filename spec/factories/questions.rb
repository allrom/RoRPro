FactoryBot.define do
  factory :question do
    title { "MyTitle" }
    body { "MyText" }

    trait :invalid do
      title { nil }
    end
  end
end
