class FeedbackNumberCacheWorker
	# Redis
	require "redis"

	include Sidekiq::Worker

	def perform(company_token)
		redis = Redis.new
		Feedback.reindex
		redis.set(company_token || 'all_companies', Feedback.search(company_token || '*',	fields: [{company_token: :exact}]).size) if company_token
	end
end
