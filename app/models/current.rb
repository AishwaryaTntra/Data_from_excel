# frozen_string_literal: true

# app > models > current
class Current < ActiveSupport::CurrentAttributes
  attribute :user
  cattr_accessor :current_user
end
