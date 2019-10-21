FactoryBot.define do
  factory :authorization do
    provider  { 'testprovider' }
    uid  { '123456' }

    user
  end
end
