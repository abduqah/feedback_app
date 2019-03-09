class Feedback < ApplicationRecord

	accepts_nested_attributes_for :state

	# Default values
	default_scope { order(created_at: :desc) }
	enum priority: { minor: 1, major: 2, critical: 3 }

	# Relations
	has_one :state, dependent: :destroy

	# Validations
	validates_presence_of :company_token, :priority
	validates_uniqueness_of :number, scope: :company_token
	validates_inclusion_of :priority, in: %w(minor major critical), message: 'priority must be in ( 1, 2, 3 ) for minor, major or critical respectively'
	
	# callbacks
	after_save :create_json_cache

	def generate_number
		# this implementation is trivial for no recored shall be deleted
		# numbers start from 1
		last_feedback = Feedback.where(company_token: company_token).first
		last_number = last_feedback.present? ? last_feedback.number : 0
		number = last_number + 1
	end

	def self.cache_key(feedbacks)
		{
			serializer: "feedbacks_#{@company_token}",
			stat_record: feedbacks.maximum(:updated_at)
		}
	end

	private

		def create_json_cache
			CreateFeedbacksJsonWorker.perform_async()
		end

end
