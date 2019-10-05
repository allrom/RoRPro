FactoryBot.define do
  factory :comment do |comment|
    comment.commentable { |a_comment| a_comment.association(:question) }

    body { "BotComment" }

    user

    trait :invalid do
      body { nil }
    end
  end
end
