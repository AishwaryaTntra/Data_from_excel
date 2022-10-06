FactoryBot.define do
  factory :location do
    trait :location1 do
      name { 'location 1' }
    end

    trait :location2 do
      name { 'location 2' }
    end

    trait :location3 do
      name { 'location 3' }
    end
  end
end