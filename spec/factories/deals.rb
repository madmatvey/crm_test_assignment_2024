# frozen_string_literal: true

FactoryBot.define do
  factory :deal do
    sequence(:name) { |n| "Deal #{n}" }
    amount { rand(10..1000) }
    status { %w[pending won lost].sample }
    company
  end
end
