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

      after(:create) do |q, e|
        create_list(:answer, e.number_of_answers, question: q)
      end
    end

    trait :with_answer do
      after(:create) do |q|
        create(:answer, question: q)
      end
    end

    trait :with_attachment do
      after(:create) do |q|
        file = File.new("#{Rails.root}/spec/factories/patterns/data")
        q.files.attach(io: file, filename: "test_q_data")
      end
    end

    trait :with_link do
      after(:create) do |q|
        create(:link, linkable: q, url: 'https://ya.ru')
      end
    end

    trait :with_award do
      after(:create) do |q|
        create(:award, question: q)
      end
    end
  end
end
