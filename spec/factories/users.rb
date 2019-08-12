FactoryBot.define do
  sequence :email do |num|
    "student#{num}@test.edu"
  end

  factory :user do
    email
    password { '12345678' }
    password_confirmation { '12345678' }
  end
end
