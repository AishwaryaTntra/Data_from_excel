FactoryBot.define do
  factory :user do
    password { '123456' }
    trait :user1 do
      name { 'User 1' }
      email { 'user1@gmail.com' }
      phone { '1234567890' }
    end

    trait :user2 do
      name { 'User 2' }
      email { 'user2@gmail.com' }
      phone { '2345678901' }
    end

    trait :user1 do
      name { 'User 3' }
      email { 'user3@gmail.com' }
      phone { '3456789012' }
    end

    trait :user4 do
      name { 'User 4' }
      email { 'user4@gmail.com' }
      phone { '4567890123' }
    end

    trait :user5 do
      name { 'User 5' }
      email { 'user5@gmail.com' }
      phone { '5678901234' }
    end
  end
end
