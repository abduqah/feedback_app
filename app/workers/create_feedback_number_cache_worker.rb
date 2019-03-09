class CreateFeedbackNumberCacheWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(company_token)
	end
end
