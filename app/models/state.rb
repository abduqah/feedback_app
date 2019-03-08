class State < ApplicationRecord
	belongs_to :feedback
	validates_presence_of :device, :os
end
