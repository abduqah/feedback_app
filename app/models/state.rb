class State < ApplicationRecord
  belongs_to :feedback, touch: true
  validates_presence_of :device, :os
  validates_numericality_of :memory, :storage, only_integer: true, allow_nil: true, greater_than: 0
end
