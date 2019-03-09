class CreateFeedbackJsonCacheWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(company_token)
		feedbacks = Feedback.includes(:states)
		json = Rails.cache.fetch(Feedback.cache_key(feedbacks)) do
			feedbacks.where(company_token: company_token).to_json(include: :states)
		end
	end
end
