FactoryBot.define do
  factory :award do
    sequence(:name) { |n| "Award_#{n}" }
    image { Rack::Test::UploadedFile.new( "#{Rails.root}/app/assets/images/one_star.png", 'image/png'   )}

    question
    user
  end
end
