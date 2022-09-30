FactoryBot.define do
  factory :customer do
    trait :customer1 do
      name { 'Customer 1' }
      email { 'customer1@gmail.com' }
      phone { '1234567890' }
    end

    trait :customer2 do
      name { 'Customer 2' }
      email { 'customer2@gmail.com' }
      phone { '2345678901' }
    end

    trait :customer3 do
      name { 'Customer 3' }
      email { 'customer3@gmail.com' }
      phone { '3456789012' }
    end
  end
end
