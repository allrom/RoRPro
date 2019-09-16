FactoryBot.define do
  factory :link do
    sequence(:name) { |n| "SomeLink_#{n}" }
    sequence(:url) { |n| "http://link_#{n}.edu" }
  end
end
