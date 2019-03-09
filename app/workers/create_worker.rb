class CreateWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(feedback)
		feedback.generate_number
		Rails.cache.fetch('number') {feedback.number}
		feedback.save!
  end
end
