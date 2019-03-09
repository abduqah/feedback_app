class Feedback < ApplicationRecord
	# Default values
	default_scope { order(created_at: :desc) }
	enum priority: { minor: 1, major: 2, critical: 3 }

	# Relations
	has_one :state, dependent: :destroy

	# Validations
	validates_presence_of :company_token, :number, :priority
	validates_uniqueness_of :number, scope: :company_token
	validates_inclusion_of :priority, in: %w(minor major critical), message: 'priority must be in ( 1, 2, 3 ) for minor, major or critical respectively'
	
	def self.generate_number(company_token)
		# this implementation is trivial for no recored shall be deleted
		# numbers start from 1
		last_feedback = Feedback.where(company_token: company_token).first
		last_number = last_feedback.present? ? last_feedback.number : 0
		number = last_number + 1
	end
end
