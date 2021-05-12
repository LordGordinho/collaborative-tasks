FactoryBot.define do
  factory :list do
    name { Faker::Lorem.sentence }
    user 
  end
end
