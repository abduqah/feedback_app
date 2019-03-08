class Feedback < ApplicationRecord
	extend Enumerize

	default_scope { order(created_at: :desc) }

	has_one :state, dependent: :destroy
	validates_presence_of :company_token, :number, :priority
	validates_uniqueness_of :company_token
	validates_uniqueness_of :number, scope: :company_token
	enumerize :priority, in: { minor: 1, major: 2, critical: 3 }
	validates_inclusion_of :priority, in: 1..3, message: 'priority must be in ( 1, 2, 3 ) for minor, major or critical respectively'

	after_create :generate_number
	
	def generate_number
		# this implementation is trivial for no recored shall be deleted
		# numbers start from 1
		last_feedback = Feedback.where(company_token: company_token).first
		last_number = last_feedback? ? last_feedback.number : 0
		update_column(number, last_number + 1)
	end
end
