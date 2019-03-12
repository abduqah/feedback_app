class FeedbackNumberCacheWorker
	# Redis
	require "redis"

	include Sidekiq::Worker

	def perform(company_token)
		redis = Redis.new
		redis.set(company_token, Feedback.search(company_token || '*',	fields: [{company_token: :exact}]).size)
	end
end
