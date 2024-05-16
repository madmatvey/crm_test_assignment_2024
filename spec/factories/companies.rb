# frozen_string_literal: true

FactoryBot.define do
  factory :company do
    name { Faker::Company.name }
    employee_count { rand(10..1000) }
    industry { Faker::Company.industry }
  end
end
