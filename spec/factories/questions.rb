FactoryBot.define do
  factory :question do
    sequence(:title) { |n| "BotTitle_#{n}" }
    body { "BotQuestion" }

    user

    trait :invalid do
      title { nil }
    end

    trait :with_answers do
      transient do
        number_of_answers { 3 }
      end

      after(:create) do |question, evaluator|
        create_list(:answer, evaluator.number_of_answers, question: question)
      end
    end

    trait :with_answer do
      after(:create) do |question|
        create(:answer, question: question)
      end
    end

    trait :with_attachment do
      after(:create) do |question|
        file = File.new("#{Rails.root}/spec/factories/patterns/data")
        question.files.attach(io: file, filename: "test_q_data")
      end
    end

    trait :with_link do
      after(:create) do |question|
        create(:link, linkable: question, url: 'https://ya.ru')
      end
    end

    trait :with_award do
      after(:create) do |question|
        create(:award, question: question)
      end
    end

    trait :upvoted do
      after(:create) do |question|
        create(:vote, votable: question, number_of: 1)
      end
    end

    trait :downvoted do
      after(:create) do |question|
        create(:vote, votable: question, number_of: -1)
      end
    end
  end
end
