FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "BotAnswer_#{n}" }

    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after(:create) do |a|
        file = File.new("#{Rails.root}/spec/factories/patterns/data")
        a.files.attach(io: file, filename: "test_a_data")
      end
    end

    trait :with_link do
      after(:create) do |a|
        create(:link, linkable: a, url: 'https://google.com')
      end
    end

    trait :with_link do
      after(:create) do |a|
        create(:link, answer: a)
      end
    end
  end
end
