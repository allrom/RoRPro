FactoryBot.define do
  factory :comment do |comment|
    comment.commentable { |a_comment| a_comment.association(:question) }

    sequence(:body) { |n| "BotComment_#{n}" }

    user

    trait :invalid do
      body { nil }
    end
  end
end
