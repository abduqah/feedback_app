class CreateWorker
  include Sidekiq::Worker

  def perform(feedback_attributes, state_attributes)
    ActiveRecord::Base.transaction do
      feedback = Feedback.new(feedback_attributes)
      feedback.state = State.new(state_attributes)
      feedback.save!
    end
  end
end
