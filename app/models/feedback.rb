class Feedback < ApplicationRecord
	has_one :state, dependent: :destroy
	validates_presence_of :company_token, :number, :priority
	validates_uniqueness_of :company_token
	validates_uniqueness_of :number, scope: :company_token
	enumerize :priority, in: { minor: 1, major: 2, critical: 3 }
	validates_inclusion_of :priority, in: 1..3, message: 'priority must be in 1 for minor, 2 for major or 3 for critical'
end
