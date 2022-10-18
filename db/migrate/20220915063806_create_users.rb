# frozen_string_literal: true

# db > migrate > create_users
class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users, if_not_exists: true do |t|
      t.string :name
      t.string :email
      t.string :phone

      t.timestamps
    end
  end
end
