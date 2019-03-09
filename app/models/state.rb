class State < ApplicationRecord
	belongs_to :feedback, touch: true
	validates_presence_of :device, :os
end
