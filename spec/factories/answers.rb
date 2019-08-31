FactoryBot.define do
  factory :answer do
    sequence(:body) { |n| "BotAnswer_#{n}" }

    question
    user

    trait :invalid do
      body { nil }
    end

    trait :with_attachment do
      after(:create) do |q|
        file = File.new("#{Rails.root}/spec/factories/patterns/data")
        q.files.attach(io: file, filename: "test_a_data")
      end
    end
  end
end
