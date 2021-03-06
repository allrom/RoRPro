FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "BotAnswer_#{n}" }

    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after(:create) do |answer|
        file = File.new("#{Rails.root}/spec/factories/patterns/data")
        answer.files.attach(io: file, filename: "test_a_data")
      end
    end

    trait :with_link do
      after(:create) do |answer|
        create(:link, linkable: answer, url: 'https://google.com')
      end
    end

    trait :upvoted do
      after(:create) do |answer|
        create(:vote, votable: answer, number_of: 1)
      end
    end

    trait :downvoted do
      after(:create) do |answer|
        create(:vote, votable: answer, number_of: -1)
      end
    end
  end
end
