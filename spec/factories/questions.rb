FactoryBot.define do
  factory :question do
    title { "BotTitle" }
    body { "BotQuestion" }

    user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      transient do
        number_of_answers { 3 }
      end

      after(:create) do |q, e|
        create_list(:answer, e.number_of_answers, question: q)
      end
    end
  end
end
