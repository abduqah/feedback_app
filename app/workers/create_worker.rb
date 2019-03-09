class CreateWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(feedback_params, number)
		feedback = Feedback.create(feedback_params)
		feedback.company_token = @company_token
		feedback.number = number
		feedback.save!
  end
end
