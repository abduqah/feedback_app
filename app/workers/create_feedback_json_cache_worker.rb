class CreateFeedbackJsonCacheWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(*args)
		feedbacks = @company_token.present? ? Feedback.where(company_token: @company_token).includes(:states) : Feedback.includes(:states)
		json = Rails.cache.fetch(Feedback.cache_key(feedbacks)) do
			feedbacks.to_json(include: :states)
		end
	end
end
