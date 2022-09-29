class Current < ActiveSupport::CurrentAttributes
  attribute :user
  cattr_accessor :current_user
end