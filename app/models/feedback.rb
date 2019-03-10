class Feedback < ApplicationRecord

	# Default values
	default_scope { order(created_at: :desc) }
	enum priority: { minor: 1, major: 2, critical: 3 }

	# Relations
	has_one :state, dependent: :destroy
	accepts_nested_attributes_for :state, reject_if: :reject_state

	# Validations
	validates_presence_of :company_token, :priority, :number
	validates_uniqueness_of :number, scope: :company_token
	validates_inclusion_of :priority, in: %w(minor major critical), message: 'priority must be in ( 1, 2, 3 ) for minor, major or critical respectively'

	# Callbacks
	after_commit :set_company_number

	# searchkick
	searchkick searchable: [:company_token, :number]

	def set_company_number
		FeedbackNumberCacheWorker.perform_async(company_token)
	end
end
