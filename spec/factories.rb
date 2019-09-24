# frozen_string_literal: true

FactoryBot.define do
  factory :task do
    title { 'Wash Laundry' }
  end

  factory :tag do
    title { 'Today' }
  end
end
