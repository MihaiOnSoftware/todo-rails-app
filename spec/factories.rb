# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Wash Laundry' }

    trait :with_tag do
      tags { [build(:tag)] }
    end
  end

  factory :tag do
    title { 'Today' }

    trait :with_task do
      tasks { [build(:task)] }
    end
  end
end
