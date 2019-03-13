class Feedback < ApplicationRecord

	# Default values
	enum priority: { minor: 1, major: 2, critical: 3 }

	# Relations
	has_one :state, dependent: :destroy
	accepts_nested_attributes_for :state, reject_if: :reject_state#, message: ': Device and OS are mandatory'

	# Validations
	validates_presence_of :company_token, :priority, :number
	validates_uniqueness_of :number, scope: :company_token
	validates_inclusion_of :priority, in: %w(minor major critical), message: ': Priority must be in ( 1, 2, 3 ) for minor, major or critical respectively'

	# Callbacks
	after_commit :set_company_number

	# searchkick
	searchkick searchable: [:company_token]#, callbacks: :asyncs

	scope :search_import, -> { includes(:state) }

	def search_data
		{ company_token: company_token }
	end

	def set_company_number
		FeedbackNumberCacheWorker.perform_async(company_token)
	end

	def reject_state(attributes)
		attributes['device'].blank? || attributes['os'].blank?
	end
	
	def self.get_feedback(search, number)
		result = []
		search.each do |feedback|
			result << feedback if feedback[:number] == number
		end
		result
	end
end
