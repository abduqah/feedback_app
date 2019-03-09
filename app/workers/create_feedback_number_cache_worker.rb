class CreateFeedbackNumberCacheWorker
	include Sidekiq::Worker

	def perform(company_token)
		feedbacks = Feedback.includes(:states)
		Rails.cache.fetch(Feedback.cache_key(feedbacks))
		feedbacks_number = Feedback.where(company_token: company_token).size
		number = Rails.cache.fetch(Feedback.cache_key(company_token)) do
			feedbacks_number + 1
		end
	end
end
