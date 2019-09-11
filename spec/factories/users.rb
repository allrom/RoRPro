FactoryBot.define do
  sequence :email do |num|
    "student#{num}@test.edu"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }

    trait :with_award do
      after(:create) do |user|
        create(:award, user: user)
      end
    end
  end
end
