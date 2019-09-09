FactoryBot.define do
  factory :award do
    sequence(:name) { |n| "Award_#{n}" }
    image_filename { "one_star.png" }

    question
    user

    trait :invalid do
      image_filename { nil }
    end
  end
end
