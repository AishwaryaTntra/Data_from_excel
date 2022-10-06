# frozen_string_literal: true

FactoryBot.define do
  factory :role do
    trait :user do
      name { 'User' }
    end
    trait :admin do
      name { 'Admin' }
    end
  end
end
