# frozen_string_literal: true

# db > migrate > add_role_to_users
class AddRoleToUsers < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :role, foreign_key: true
  end
end
