FactoryBot.define do
  factory :city do
    trait :city1 do
      name { 'city 1' }
    end

    trait :city2 do
      name { 'city 2' }
    end

    trait :city3 do
      name { 'city 3' }
    end
  end
end 