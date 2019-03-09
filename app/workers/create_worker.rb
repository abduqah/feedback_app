class CreateWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(feedback)
		feedback.save!
  end
end
