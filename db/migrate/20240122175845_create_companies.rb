# frozen_string_literal: true

class CreateCompanies < ActiveRecord::Migration[7.0]
  def change
    create_table :companies do |t|
      t.string :name # rubocop:disable Migration/ReservedWordMysql
      t.integer :employee_count
      t.string :industry

      t.timestamps
    end
  end
end
