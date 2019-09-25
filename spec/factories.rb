# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Wash Laundry' }
    tags { [create(:tag)] }
  end

  factory :tag do
    title { 'Today' }
  end
end
