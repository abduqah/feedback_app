class FeedbackNumberCacheWorker
  # Redis
  require "redis"

  include Sidekiq::Worker
  sidekiq_options queue: 'low'

  def perform(company_token)
    # Just incase something happened to radis data
    redis = Redis.new
    Feedback.reindex
    redis.set(company_token, Feedback.search(company_token,	fields: [{company_token: :exact}]).size) if company_token && redis.incr(company_token) == 1
  end
end
