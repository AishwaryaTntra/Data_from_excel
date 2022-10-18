# frozen_string_literal: true

# db > migrate > create_cities
class CreateCities < ActiveRecord::Migration[7.0]
  Rake::Task['db:migrate:ignore_concurrent'].invoke
  def change
    create_table :cities do |t|
      t.string :name
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
