FactoryBot.define do
  factory :message do
    trait :message1 do
      title { 'Show 1 invitation' }
      body { 'Please join us for Show 1 at Venue 1.'}
    end

    trait :message2 do
      title { 'Show 2 invitation' }
      body { 'Please join us for Show 2 at Venue 2.'}
    end

    trait :message3 do
      title { 'Show 3 invitation' }
      body { 'Please join us for Show 3 at Venue 3.'}
    end
  end
end