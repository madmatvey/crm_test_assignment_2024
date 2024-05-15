# frozen_string_literal: true

class Company < ApplicationRecord
  has_many :deals, dependent: :destroy

  scope :by_name, lambda { |name|
    where('LOWER(name) LIKE LOWER(?)', "%#{name}%")
  }

  scope :by_industry, lambda { |industry|
    where('LOWER(industry) LIKE LOWER(?)', "%#{industry}%")
  }

  scope :by_min_employee, lambda { |min_employee|
    where('employee_count >= ?', min_employee)
  }
end
