# frozen_string_literal: true

class CreateDeals < ActiveRecord::Migration[7.0]
  def change
    create_table :deals do |t|
      t.string :name # rubocop:disable Migration/ReservedWordMysql
      t.integer :amount
      t.string :status # rubocop:disable Migration/ReservedWordMysql
      t.references :company, null: false, foreign_key: true

      t.timestamps
    end
  end
end
