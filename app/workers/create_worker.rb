class CreateWorker
	include Sidekiq::Worker
	sidekiq_options retry: false

	def perform(company_token, params)
		feedback = Feedback.create(params)
		feedback.generate_number
		Rails.cache.fetch('number') {feedback.number}
		feedback.company_token = company_token
		feedback.save!
  end
end
