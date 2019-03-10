class FeedbackNumberCacheWorker
	# Redis
	require "redis"

	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(company_token)
		redis = Redis.new
		redis.exists(company_token) == 1 ? redis.get(company_token) : redis.set(company_token, Feedback.where(company_token: company_token).size)
	end
end
